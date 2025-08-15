class_name TB_Player
extends TB_Battler

func _ready() -> void:
	super()


func begin_planning() -> void:
	pass


func add_action_to_plan(action : TB_Action) -> bool:
	if (planned_turns_count == max_planned_turns
	or used_turn_plan_capacity + action.cost > turn_plan_capacity):
		return false
	if action.target_self:
		action.target = self
	else:
		action.target = get_tree().root.get_node("TBFight").enemy_battler
	planned_turns.append(action)
	used_turn_plan_capacity += action.cost
	planned_turns_count += 1
	return true
