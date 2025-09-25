class_name TB_Battler
extends Node

signal planned_action(action : TB_Action)
signal finished_planning

signal damaged
signal healed
signal died

signal applied_status_effect(status_effect : StatusEffects)
signal cleared_status_effect(status_effect : StatusEffects)

enum _States {
	ACTIVE,
	INACTIVE,
}

enum StatusEffects {
	BURN,
	FROZEN,
	ELECTRIFIED,
	RAGE,
}

@export var action_timer : Timer

var _state := _States.INACTIVE
var battler_name := ""
var armor : Armor = null
var weapon : Weapon = null
var backpack : Array[TB_Item] = []

var _used_turn_plan_capacity := 0
var _planned_turns := Queue.new()

var _health := 0
var _status_effects : Dictionary[String, int] = {
	"burn" : 0,
	"frozen" : 0,
	"electrified" : 0,
	"rage" : 0,
}

var icon : Texture2D = null
var sprite : Texture2D = null

var stunned_action : TB_Action = preload(Filepaths.MISC_ACTIONS.stunned)


func initialize_battler(battler_template : TB_BattlerTemplate) -> void:
	battler_name = battler_template.name
	armor = battler_template.armor
	weapon = battler_template.weapon
	icon = battler_template.icon
	sprite = battler_template.sprite
	_planned_turns.emptied.connect(_on_planned_turns_emptied)


func get_health() -> int:
	return _health


func damage(dmg : Damage) -> void:
	var true_damage := armor.damage(dmg)
	_health -= true_damage
	_health = clampi(_health, 0, armor.health)
	
	if true_damage > 0:
		damaged.emit()
	elif true_damage < 0:
		healed.emit()
	if _health <= 0:
		_state = _States.INACTIVE
		died.emit()


func apply_status_effect(status_effect : StatusEffects) -> void:
	var status_effect_key := get_status_effect_key(status_effect)
	if status_effect_key == "":
		return
	var new_duration = _status_effects[status_effect_key] + Constants.STATUS_DURATIONS[status_effect_key]
	if _status_effects[status_effect_key] == 0:
		applied_status_effect.emit(status_effect)
	_status_effects[status_effect_key] = clamp(new_duration, 0, Constants.STATUS_MAX_DURATIONS[status_effect_key])


func _step_status_effect(status_effect : StatusEffects) -> void:
	var status_effect_key := get_status_effect_key(status_effect)
	var new_duration = _status_effects[status_effect_key] - 1
	_status_effects[status_effect_key] = clamp(new_duration, 0, Constants.STATUS_MAX_DURATIONS[status_effect_key])
	if _status_effects[status_effect_key] == new_duration and new_duration == 0:
		cleared_status_effect.emit(status_effect)


func is_afflicted_by(status_effect : StatusEffects) -> bool:
	return _status_effects[get_status_effect_key(status_effect)] > 0


func clear_status_effect(status_effect : StatusEffects) -> void:
	_status_effects[get_status_effect_key(status_effect)] = 0
	cleared_status_effect.emit(status_effect)


func clear_status_effects() -> void:
	for key in StatusEffects.keys():
		clear_status_effect(key)


static func get_status_effect_key(status_effect : StatusEffects) -> String:
	var status_effect_key := ""
	match (status_effect):
		StatusEffects.BURN:
			status_effect_key = "burn"
		StatusEffects.FROZEN:
			status_effect_key = "frozen"
		StatusEffects.ELECTRIFIED:
			status_effect_key = "electrified"
		StatusEffects.RAGE:
			status_effect_key = "rage"
		_:
			print_debug("Incorrect status effect given")
	return status_effect_key


func plan_action(action : TB_Action) -> bool:
	if action.cost + _used_turn_plan_capacity <= weapon.turn_plan_capacity:
		_planned_turns.append(action)
		_used_turn_plan_capacity += action.cost
		planned_action.emit(action)
		return true
	return false


func next_action() -> TB_Action:
	if _planned_turns.size() == 1:
		_state = _States.INACTIVE
	var next : TB_Action = _planned_turns.next()
	if is_afflicted_by(StatusEffects.ELECTRIFIED) and randf() > Constants.ELECTRIFIED_SKIP_CHANCE:
		return stunned_action
	return next


func next_action_speed() -> int:
	return weapon.move_speed(_planned_turns.peek())


func is_active() -> bool:
	return _state == _States.ACTIVE


func finish_planning() -> void:
	if _planned_turns.size() > 0:
		_state = _States.ACTIVE
	else:
		_state = _States.INACTIVE
	finished_planning.emit()


func clear_plan() -> void:
	_planned_turns.clear()
	_used_turn_plan_capacity = 0
	_state = _States.INACTIVE


func _on_finished_planning() -> void:
	if _planned_turns.size() > 0:
		_state = _States.ACTIVE
	else:
		_state = _States.INACTIVE


func _on_planned_turns_emptied() -> void:
	_state = _States.INACTIVE
