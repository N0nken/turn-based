class_name TB_Player
extends TB_Battler

@export var backpack : Array[TB_Item] = []

func _ready() -> void:
	self.weapon = LoadedRun.player.weapon
	self.armor = LoadedRun.player.armor
	self.battler_name = LoadedRun.player.battler_name
	super()


func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_parent().get_parent().enemy_battler
	action.parent_battler = self
	return super(action)
