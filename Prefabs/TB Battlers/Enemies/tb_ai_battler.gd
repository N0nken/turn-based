class_name TB_AiBattler
extends TB_Battler

func plan_turns(smart : bool = false) -> void:
	if smart:
		_plan_smart_helper()
	else:
		_plan_dumb_helper()


func _plan_smart_helper() -> void:
	pass


func _plan_dumb_helper() -> void:
	while used_turn_plan_capacity < turn_plan_capacity:
		var next_turn : TB_Action = move_set.pick_random()
		if next_turn.target_self:
			next_turn.target = self
		else:
			next_turn.target = get_tree().root.get_node("TBFight").player_battler
