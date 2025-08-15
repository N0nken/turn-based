class_name TB_Player
extends TB_Battler

func _ready() -> void:
	super()


func plan_action(action : TB_Action) -> bool:
	if action.target_self:
		action.target = self
	else:
		action.target = get_tree().root.get_node("TBFight").enemy_battler
	return super(action)
