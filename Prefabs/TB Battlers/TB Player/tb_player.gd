class_name TB_Player
extends TB_Battler

@export var backpack : Array[TB_Item] = []

func _ready() -> void:
	self.max_health = Player.max_health
	self.health = max_health
	self.strength = Player.strength
	self.speed = Player.speed
	self.turn_plan_capacity = Player.turn_plan_capacity
	self.battler_name = Player.battler_name
	for move_code in Player.move_set:
		self.move_set.append(load(Filepaths.ATTACK_LIBRARY[move_code]))
	super()

func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_tree().root.get_node("TBFight").enemy_battler
	return super(action)
