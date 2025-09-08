class_name TB_AiBattler
extends TB_Battler

signal initialized

@export var template : Enemy = null
@export var stat_bias : Dictionary[String,int] = {
	"health" : 0,
	"strength" : 0,
	"speed" : 0,
	"defense" : 0,
	"turn_plan_capacity" : 0,
}
@export var sprite : Sprite2D = null

func _ready() -> void:
	super()


func initialize_battler() -> void:
	for i in range(template.move_set.size()):
		var duped_action : TB_Action = template.move_set[i].duplicate(true)
		duped_action.parent_battler = self
		duped_action.tb_fight_root = get_parent().get_parent()
		self.move_set.append(duped_action)
	self.battler_name = template.name
	max_health = template.base_stats["health"] + stat_bias["health"] * LoadedRun.stage 
	health = max_health
	strength = template.base_stats["strength"] + stat_bias["strength"] * LoadedRun.stage
	speed = template.base_stats["speed"] + stat_bias["speed"] * LoadedRun.stage
	defense = template.base_stats["defense"] + stat_bias["defense"] * LoadedRun.stage
	turn_plan_capacity = template.base_stats["turn_plan_capacity"] + stat_bias["turn_plan_capacity"] * LoadedRun.stage
	sprite.texture = template.sprite
	sprite.position = sprite.texture.get_size() / 2.0
	self.icon = template.icon
	initialized.emit()


func plan_turns(smart : bool = false) -> void:
	if smart:
		_plan_smart_helper()
	else:
		_plan_dumb_helper()


func _plan_smart_helper() -> void:
	pass


func _plan_dumb_helper() -> void:
	if move_set.size() == 0:
		finish_planning()
		return
	while used_turn_plan_capacity < turn_plan_capacity and planned_turns.size() < max_planned_turns:
		var next_turn : TB_Action = move_set.pick_random()
		if next_turn.target_self:
			next_turn.target = self
		else:
			next_turn.target = get_parent().get_parent().player_battler
		
		if used_turn_plan_capacity + next_turn.cost <= turn_plan_capacity:
			planned_turns.append(next_turn)
			used_turn_plan_capacity += next_turn.cost
		
		var no_available_action := true
		for action in move_set:
			if used_turn_plan_capacity + action.cost <= turn_plan_capacity:
				no_available_action = false
		if no_available_action:
			break
	finish_planning()
