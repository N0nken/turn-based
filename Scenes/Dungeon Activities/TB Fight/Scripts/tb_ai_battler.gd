class_name TB_AiBattler
extends TB_Battler

func initialize_battler(battler_template : TB_BattlerTemplate) -> void:
	super(battler_template)
	
	_health = armor.health


func plan_turns(smart : bool = false) -> void:
	if smart:
		_plan_smart_helper()
	else:
		_plan_dumb_helper()


func _plan_smart_helper() -> void:
	pass


func _plan_dumb_helper() -> void:
	if weapon.move_set.size() == 0:
		finished_planning.emit()
		return
	
	var available_move_set := weapon.move_set.duplicate()
	
	while (_used_turn_plan_capacity < weapon.turn_plan_capacity
			and _planned_turns.size() < TB_Fight.MAX_PLANNED_TURNS
			and available_move_set.size() > 0):
		var next_turn : TB_Move = available_move_set.pick_random()
		plan_action(next_turn)
		
		for move in available_move_set:
			if move.cost + _used_turn_plan_capacity >= weapon.turn_plan_capacity:
				available_move_set.erase(move)
	
	finish_planning()
