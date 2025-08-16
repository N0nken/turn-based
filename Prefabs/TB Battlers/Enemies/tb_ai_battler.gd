class_name TB_AiBattler
extends TB_Battler

@export var level := 1

func _ready() -> void:
	super()


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
			next_turn.target = get_tree().root.get_node("TBFight").player_battler
		
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
