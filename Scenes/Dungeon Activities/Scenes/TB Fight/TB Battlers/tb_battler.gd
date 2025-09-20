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

# Status effects
signal status_effect_ended(status_effect : StatusEffects)
signal status_effect_applied(status_effect : StatusEffects)

enum StatusEffects {
	RAGE,
	BURN,
	FROZEN,
	ELECTRIFIED,
}

const max_planned_turns := 5

@export var battler_name := ""
@export var icon : Texture2D = null
@export var gold_drop := 0
@export var hurt_sound_effect : AudioStream = null
@export var death_sound_effect : AudioStream = null
@export var max_combo_count := 10
@export var weapon : Weapon = null
@export var armor : Armor = null

var used_turn_plan_capacity := 0
var planned_turns := Queue.new()

var alive : bool = true
var active : bool = false
var combo_count := 0
var status_effects : Dictionary[String, int] = {
	"rage" : 0,
	"burn" : 0,
	"frozen" : 0,
	"electrified" : 0,
}


@onready var latest_action_timer : Timer = get_node("LatestActionTimer")
@onready var hit_effect_timer : Timer = get_node("HitEffectTimer")
@onready var health := armor.health


func _ready() -> void:
	latest_action_timer.timeout.connect(_action_ended)
	damaged.connect(_on_damaged)
	hit_effect_timer.timeout.connect(_on_hit_effect_end)


func damage(dmg : Damage) -> void:
	armor.damage(dmg)


func plan_action(action : TB_Action) -> bool:
	if (planned_turns.size() == max_planned_turns
	or used_turn_plan_capacity + action.cost > weapon.turn_plan_capacity):
		return false
	planned_turns.append(action)
	used_turn_plan_capacity += action.cost
	return true


func finish_planning() -> void:
	active = true
	finished_planning.emit()


func execute_next_action() -> void:
	var next_action : TB_Action = planned_turns.pop_front()
	latest_action_timer.start(next_action.life_time)
	action_started.emit(next_action, self)
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


func next_action_speed() -> int:
	if planned_turns.size() == 0 or not active or not alive:
		return -1
	var next_speed : int = weapon.move_speed(planned_turns.peek())
	if status_effects.frozen > 0:
		next_speed /= 2
	return next_speed


func _action_ended() -> void:
	action_ended.emit()


# ---- Status Effects ----
func apply_status_effect(status_effect : StatusEffects) -> void:
	match status_effect:
		StatusEffects.RAGE:
			if status_effects.rage < Constants.STATUS_DURATIONS.rage:
				status_effects.rage = Constants.STATUS_DURATIONS.rage
				status_effect_applied.emit(StatusEffects.RAGE)
		StatusEffects.BURN:
			if status_effects.burn == 0:
				status_effect_applied.emit(StatusEffects.BURN)
			status_effects.burn += Constants.STATUS_DURATIONS.burn
			
		StatusEffects.FROZEN:
			if status_effects.frozen == 0:
				status_effect_applied.emit(StatusEffects.FROZEN)
			status_effects.frozen += Constants.STATUS_DURATIONS.frozen
			
		StatusEffects.ELECTRIFIED:
			if status_effects.electrified == 0:
				status_effect_applied.emit(StatusEffects.ELECTRIFIED)
			status_effects.electrified += Constants.STATUS_DURATIONS.electrified


func step_status_effects() -> void:
	_step_burn()
	_step_frozen()
	_step_electrified()
	_step_rage()


func _step_burn() -> void:
	if status_effects.burn > 0:
		self.damage(Damage.new(Damage.DamageTypes.PHYSICAL, 0))
		status_effects.burn = clampi(status_effects.burn - 1, 0, Constants.STATUS_MAX_DURATIONS.burn)
		
		if status_effects.burn == 0:
			status_effect_ended.emit(StatusEffects.BURN)


func _step_frozen() -> void:
	if status_effects.frozen > 0:
		status_effects.frozen = clampi(status_effects.frozen - 1, 0, Constants.STATUS_MAX_DURATIONS.frozen)
		
		if status_effects.frozen == 0:
			status_effect_ended.emit(StatusEffects.FROZEN)


func _step_electrified() -> void:
	if status_effects.electrified > 0:
		if status_effects.frozen == 0:
			status_effects.electrified = clampi(status_effects.electrified - 1, 0, Constants.STATUS_MAX_DURATIONS.electrified)
		
		if status_effects.electrified == 0:
			status_effect_ended.emit(StatusEffects.ELECTRIFIED)


func _step_rage() -> void:
	if status_effects.rage > 0:
		status_effects.rage = clampi(status_effects.rage - 1, 0, Constants.status_durations.rage)
	
		if status_effects.rage == 0:
			status_effect_ended.emit(StatusEffects.RAGE)


# ---- Signals ----
func _on_damaged(_dmg : int) -> void:
	hit_effect_timer.start()
	self.material.set_shader_parameter("enabled", true)


func _on_hit_effect_end() -> void:
	self.material.set_shader_parameter("enabled", false)
