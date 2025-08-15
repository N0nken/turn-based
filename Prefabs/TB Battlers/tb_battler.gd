class_name TB_Battler
extends Node2D

# Action handling
signal finished_planning
signal action_started(action : TB_Action, battler : TB_Battler)
signal action_ended
signal planned_turns_finished

# Health
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
var active : bool = false

@onready var latest_action_timer : Timer = get_node("LatestActionTimer")
@onready var health := max_health

func _ready() -> void:
	for action in move_set:
		action.parent_battler = self
		action.tb_fight_root = get_tree().root.get_node("TBFight")
	latest_action_timer.timeout.connect(_action_ended)


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


func plan_action(action : TB_Action) -> bool:
	if (planned_turns_count == max_planned_turns
	or used_turn_plan_capacity + action.cost > turn_plan_capacity):
		return false
	planned_turns.append(action)
	used_turn_plan_capacity += action.cost
	planned_turns_count += 1
	return true


func finish_planning() -> void:
	active = true
	finished_planning.emit()


func execute_next_action() -> void:
	latest_action_timer.start(planned_turns[0].life_time)
	action_started.emit(planned_turns[0], self)
	planned_turns.pop_front().action()
	if planned_turns.size() == 0:
		planned_turns_finished.emit()


func _action_ended() -> void:
	action_ended.emit()
	
