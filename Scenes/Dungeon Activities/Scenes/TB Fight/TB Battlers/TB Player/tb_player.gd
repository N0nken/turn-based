class_name TB_Player
extends TB_Battler

@export var backpack : Array[TB_Item] = []

func _ready() -> void:
	self.max_health = LoadedRun.player.max_health
	self.health = LoadedRun.player.health
	self.strength = LoadedRun.player.strength
	self.speed = LoadedRun.player.speed
	self.turn_plan_capacity = LoadedRun.player.turn_plan_capacity
	self.battler_name = LoadedRun.player.battler_name
	for move_code in LoadedRun.player.move_set:
		self.move_set.append(load(Filepaths.ATTACKS[move_code]))
	super()


func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_parent().get_parent().enemy_battler
	action.parent_battler = self
	return super(action)
