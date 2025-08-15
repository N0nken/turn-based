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

var active_battlers : Array[TB_Battler] = []
var player_battler : TB_Player = null
var enemy_battler : TB_AiBattler = null
var end_fight_after_action := false
var player_fled := false

var phase := Phases.PLANNING

@onready var end_screen_timer : Timer = get_node("EndScreenTimer")

func _ready() -> void:
	for battler in get_tree().get_nodes_in_group("TB_Battlers"):
		if battler is TB_Player:
			player_battler = battler
			battler.finished_planning.connect(_on_player_finished_planning)
		elif battler is TB_AiBattler:
			enemy_battler = battler
		battler.action_ended.connect(_on_battler_action_ended)
		battler.planned_turns_finished.connect(_on_battler_planned_turns_finished.bind(battler))
		battler.died.connect(_on_battler_died.bind(battler))


func _on_player_finished_planning() -> void:
	print("player finished planning")
	print("phase: ", phase)
	if phase != Phases.PLANNING:
		return
	phase = Phases.EXECUTING
	_reactivate_battlers()
	_execute_next_action()


func _on_battler_action_ended() -> void:
	print("action ended")
	if end_fight_after_action:
		_end_fight()
	_execute_next_action()


func _on_battler_planned_turns_finished(battler : TB_Battler) -> void:
	active_battlers.erase(battler)
	if active_battlers.size() == 0:
		player_battler.begin_planning()


func _on_battler_died(_battler : TB_Battler) -> void:
	_end_fight()


func _select_next_battler() -> TB_Battler:
	var fastest_battler : TB_Battler = null
	var fastest_speed : int = 0 
	for battler in active_battlers:
		var new_battler_speed : int = battler.speed * battler.planned_turns[0].speed
		if new_battler_speed > fastest_speed:
			fastest_speed = new_battler_speed
			fastest_battler = battler
		elif new_battler_speed == fastest_speed:
			if randf() < 0.5:
				fastest_battler = battler
	return fastest_battler


func _execute_next_action() -> void:
	if phase != Phases.EXECUTING:
		return
	var next_battler = _select_next_battler()
	if next_battler:
		next_battler.execute_next_action()


func _reactivate_battlers() -> void:
	if player_battler.planned_turns_count > 0:
		active_battlers.append(player_battler)
		player_battler.planned_turns_count = 0
	if enemy_battler.planned_turns_count > 0:
		active_battlers.append(enemy_battler)
		enemy_battler.planned_turns_count = 0
	print(active_battlers)


func _end_fight() -> void:
	print("ended fight")
	phase = Phases.ENDING
	var player_won := true
	if player_battler.health <= 0 or player_fled:
		player_won = false
	fight_ended.emit(player_won)
	end_screen_timer.start()


func _on_end_screen_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Adventure/adventure.tscn")
