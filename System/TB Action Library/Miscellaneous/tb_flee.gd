class_name TB_Flee
extends TB_Action

var attempts := 0

func action() -> void:
	var flee_chance : float = (speed * 32 / ((speed/4)%256)) + 30*attempts
	if randf() < flee_chance:
		var tb_fight_root := get_tree().root.get_node("TBFight")
		if tb_fight_root:
			tb_fight_root._end_fight()
	else:
		attempts += 1
	
