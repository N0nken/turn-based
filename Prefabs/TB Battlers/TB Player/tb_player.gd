class_name TB_Player
extends TB_Battler

@export var backpack : Array[TB_Item] = []


func _ready() -> void:
	self.max_health = Commons.player.max_health
	self.health = Commons.player.health
	self.strength = Commons.player.strength
	self.speed = Commons.player.speed
	self.turn_plan_capacity = Commons.player.turn_plan_capacity
	self.battler_name = Commons.player.battler_name
	for move_code in Commons.player.move_set:
		self.move_set.append(load(Filepaths.ATTACKS[move_code]))
	super()


func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_parent().get_parent().enemy_battler
	return super(action)
