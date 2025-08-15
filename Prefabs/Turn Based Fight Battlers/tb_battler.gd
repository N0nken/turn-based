class_name TB_Battler
extends Node2D

signal finished_planning
signal action_used
signal action_ended
signal planned_turns_finished
signal damaged(damage : int)
signal healed(heal : int)
signal died

const max_planned_turns := 5

@export var turn_plan_capacity := 0
@export var strength := 1
@export var speed := 1
@export var move_set : Array[TB_Action] = []
@export var max_health := 0
@export var battler_name := ""

var used_turn_plan_capacity := 0
var planned_turns : Array[TB_Action] = []
var planned_turns_count := 0

var alive : bool = true

@onready var latest_action_timer : Timer = get_node("LatestActionTimer")
@onready var health := max_health

func _ready() -> void:
	for action in move_set:
		action.parent_battler = self
		action.tb_fight_root = get_tree().root.get_node("TBFight")
		action.action_used.connect(_on_action_used)
	latest_action_timer.timeout.connect(_action_ended)


func execute_next_action() -> void:
	if planned_turns.size() == 0:
		return
	var next_action : TB_Action = planned_turns.pop_front()
	next_action.action()


func _action_ended() -> void:
	if planned_turns.size() == 0:
		planned_turns_finished.emit()
	else:
		action_ended.emit()


func damage(dmg : int) -> void:
	health -= dmg
	health = clamp(health, 0, max_health)
	
	if dmg > 0:
		damaged.emit(dmg)
	elif dmg < 0:
		healed.emit(dmg)
	if health <= 0:
		print(self, " died")
		died.emit()
	
	print(health, " ", dmg)


func finish_planning() -> void:
	used_turn_plan_capacity = 0
	finished_planning.emit()


func _on_action_used(action : TB_Action) -> void:
	latest_action_timer.start(0.5)
	action_used.emit(action, self)
