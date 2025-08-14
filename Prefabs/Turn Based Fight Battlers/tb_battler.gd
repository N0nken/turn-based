class_name TB_Battler
extends Node2D

signal echo_action_ended
signal planned_turns_finished
signal echo_died

@export var health_component : HealthComponent = null
@export var turn_plan_capacity := 0
@export var strength := 1
@export var speed := 1

var used_turn_plan_capacity := 0
var planned_turns : Array[TB_Action] = []
var move_set : Array[TB_Action] = []
var alive : bool = true

func _ready() -> void:
	for node in get_children():
		if node is TB_Action:
			move_set.append(node)
			node.action_ended.connect()
	health_component.died.connect(_on_died)


func execute_next_action() -> void:
	if planned_turns.size() == 0:
		return
	var next_action : TB_Action = planned_turns.pop_front()
	next_action.action()


func action_ended() -> void:
	if planned_turns.size() == 0:
		planned_turns_finished.emit()
	else:
		echo_action_ended.emit()


func _on_died() -> void:
	echo_died.emit()
