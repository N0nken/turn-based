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

@export var battler_name := ""
@export var max_health := 0
@export var strength := 1
@export var speed := 1
@export var defense := 1
@export var turn_plan_capacity := 0
@export var icon : Texture2D = null
@export var gold_drop := 0
@export var hurt_sound_effect : AudioStream = null
@export var death_sound_effect : AudioStream = null
@export var max_combo_count := 10


var used_turn_plan_capacity := 0
var planned_turns : Array[TB_Action] = []
var move_set : Array[TB_Action]

var alive : bool = true
var active : bool = false
var combo_count := 0

@onready var latest_action_timer : Timer = get_node("LatestActionTimer")
@onready var hit_effect_timer : Timer = get_node("HitEffectTimer")
@onready var health := max_health

func _ready() -> void:
	latest_action_timer.timeout.connect(_action_ended)
	damaged.connect(_on_damaged)
	hit_effect_timer.timeout.connect(_on_hit_effect_end)


func damage(dmg : int) -> void:
	health -= dmg
	health = clamp(health, 0, max_health)
	
	if dmg > 0:
		damaged.emit(dmg)
	elif dmg < 0:
		healed.emit(dmg)
	if health <= 0:
		died.emit()


func plan_action(action : TB_Action) -> bool:
	if (planned_turns.size() == max_planned_turns
	or used_turn_plan_capacity + action.cost > turn_plan_capacity):
		return false
	planned_turns.append(action)
	used_turn_plan_capacity += action.cost
	return true


func finish_planning() -> void:
	active = true
	finished_planning.emit()


func execute_next_action() -> void:
	latest_action_timer.start(planned_turns[0].life_time)
	action_started.emit(planned_turns[0], self)
	var next_action : TB_Action = planned_turns.pop_front()
	if next_action.target_self:
		next_action.target = self
	else:
		for battler in get_tree().get_nodes_in_group("TB_Battlers"):
			if battler != self:
				next_action.target = battler
	next_action.parent_battler = self
	next_action.action()
	if planned_turns.size() == 0:
		self.active = false
		planned_turns_finished.emit()


func _action_ended() -> void:
	action_ended.emit()


func _on_damaged(_dmg : int) -> void:
	hit_effect_timer.start()
	self.material.set_shader_parameter("enabled", true)


func _on_hit_effect_end() -> void:
	self.material.set_shader_parameter("enabled", false)
