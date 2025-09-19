class_name TB_Fight
extends DungeonActivity

signal fight_ended

enum Phases {
	PLANNING,
	EXECUTING,
	ENDING
}
enum ExitStates {
	PLAYER_WON,
	PLAYER_FLED,
	PLAYER_LOST,
}

var active_battlers : Array[TB_Battler] = []
var player_battler : TB_Player = null
var enemy_battler : TB_AiBattler = null
var end_round_early := false
var battler_fled : TB_Battler = null
var enemy_battler_template : Enemy = null
var phase := Phases.PLANNING

@onready var end_screen_timer : Timer = get_node("EndScreenTimer")

func _ready() -> void:
	for battler in get_node("Battlers").get_children():
		if battler is TB_Player:
			player_battler = battler
		elif battler is TB_AiBattler:
			enemy_battler = battler
		battler.finished_planning.connect(_on_battler_finished_planning)
		battler.action_ended.connect(_on_action_ended)
		battler.died.connect(_on_battler_died)
	if activity_args.is_boss_battle:
		enemy_battler.template = LoadedRun.active_dungeon_template.faction.bosses.pick_random()
	else:
		enemy_battler.template = LoadedRun.active_dungeon_template.faction.enemies.pick_random()
	enemy_battler.initialize_battler()
	enemy_battler.plan_turns()


func _on_battler_finished_planning() -> void:
	# Safeguard against multiple plan confirmations
	if phase != Phases.PLANNING:
		return
	if (not player_battler.active) or (not enemy_battler.active):
		return
	phase = Phases.EXECUTING
	_execute_next_action()


func _execute_next_action() -> void:
	if phase != Phases.EXECUTING:
		return
	
	var fastest_battler : TB_Battler = null
	if not (player_battler.active or enemy_battler.active) or end_round_early:
		_end_round()
		return
		
	var player_speed := player_battler.next_action_speed()
	var enemy_speed := enemy_battler.next_action_speed()
	
	var _only_one_active := false
	
	if player_speed == -1 and enemy_speed == -1:
		_end_round()
		return
	
	if player_speed == -1 or enemy_speed == -1:
		_only_one_active = true
	
	if player_speed >= enemy_speed:
		fastest_battler = player_battler
	elif enemy_speed:
		fastest_battler = enemy_battler
	
	if fastest_battler == null:
		_end_round()
		return
	
	if _only_one_active:
		fastest_battler.execute_next_action()
	elif fastest_battler.status_effects.electrified > 0 and randf() > Constants.electrified_skip_chance:
		if fastest_battler == player_battler:
			enemy_battler.execute_next_action()
		else:
			player_battler.execute_next_action()
	else:
		fastest_battler.execute_next_action()


func _on_action_ended() -> void:
	# Phase safeguard
	if phase != Phases.EXECUTING:
		return
	_execute_next_action()


func _on_battler_died() -> void:
	_end_round()


func _end_round() -> void:
	if enemy_battler.health == 0 or player_battler.health == 0 or battler_fled:
		_end_fight()
		return
	phase = Phases.PLANNING
	player_battler.used_turn_plan_capacity = 0
	enemy_battler.used_turn_plan_capacity = 0
	enemy_battler.plan_turns()
	_step_battler_status_effects()


func _end_fight() -> void:
	phase = Phases.ENDING
	LoadedRun.player.health = player_battler.health
	var exit_state := ExitStates.PLAYER_WON
	if player_battler.health <= 0:
		exit_state = ExitStates.PLAYER_LOST
	elif battler_fled == player_battler:
		exit_state = ExitStates.PLAYER_FLED
	fight_ended.emit(exit_state)
	end_screen_timer.start()
	if exit_state == ExitStates.PLAYER_WON:
		LoadedRun.player.gold += enemy_battler.gold_drop


func _step_battler_status_effects() -> void:
	player_battler.step_status_effects()
	enemy_battler.step_status_effects()


func _on_end_screen_timer_timeout() -> void:
	activity_ended.emit()
	self.queue_free()
