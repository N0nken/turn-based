class_name TB_Fight
extends Node

# FIGHT STRUCTURE
# load battlers
# player plans their actions
# player says "im ready"
# ai opponent plans their actions
# execute fasest action
# repeat ^^ until both plans are empty or one battler dies
# if either battler dies end the match
# else:
# repeat from stage 2


# FIGHT HUD
# show enemy planned moves
# show player planned moves
# show player options (moveset, flee option, item use)
# moveset
#	4 moves
#	description for each move (popup on hover?)
# backpack
#	infinite list
#	popup description on hover

signal fight_ended

enum Phases {
	PLANNING,
	EXECUTING,
	ENDING
}
enum ExitStates {
	PLAYER_WON,
	PLAYER_FLED,
	PLAYER_LOST
}

var active_battlers : Array[TB_Battler] = []
var player_battler : TB_Player = null
var enemy_battler : TB_AiBattler = null
var end_round_early := false
var battler_fled : TB_Battler = null

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
		battler.planned_turns_finished.connect(_on_battler_planned_turns_finished.bind(battler))
		battler.died.connect(_on_battler_died)
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
	var fastest_battler : TB_Battler = null
	if not (player_battler.active or enemy_battler.active) or end_round_early:
		_end_round()
		return
	elif player_battler.active and not enemy_battler.active:
		fastest_battler = player_battler
	elif enemy_battler.active and not player_battler.active:
		fastest_battler = enemy_battler
	else:
		var player_speed : int = player_battler.speed * player_battler.planned_turns[0].speed
		var enemy_speed : int = enemy_battler.speed * enemy_battler.planned_turns[0].speed
		if player_speed >= enemy_speed:
			fastest_battler = player_battler
		else:
			fastest_battler = enemy_battler
	fastest_battler.execute_next_action()


func _on_action_ended() -> void:
	# Phase safeguard
	if phase != Phases.EXECUTING:
		return
	_execute_next_action()


func _on_battler_planned_turns_finished(battler : TB_Battler) -> void:
	battler.active = false


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


func _end_fight() -> void:
	phase = Phases.ENDING
	var exit_state := ExitStates.PLAYER_WON
	if player_battler.health <= 0:
		exit_state = ExitStates.PLAYER_LOST
	elif battler_fled == player_battler:
		exit_state = ExitStates.PLAYER_FLED
	fight_ended.emit(exit_state)
	end_screen_timer.start()


func _on_end_screen_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Adventure/adventure.tscn")
