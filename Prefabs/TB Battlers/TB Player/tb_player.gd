class_name TB_Player
extends TB_Battler

@export var backpack : Array[TB_Item] = []


func _ready() -> void:
	self.max_health = RuntimePlayer.max_health
	self.health = max_health
	self.strength = RuntimePlayer.strength
	self.speed = RuntimePlayer.speed
	self.turn_plan_capacity = RuntimePlayer.turn_plan_capacity
	self.battler_name = RuntimePlayer.battler_name
	for move_code in RuntimePlayer.move_set:
		self.move_set.append(load(Filepaths.ATTACKS[move_code]))
	super()


func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_parent().get_parent().enemy_battler
	return super(action)
