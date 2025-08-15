class_name TB_Flee
extends TB_Move

func action() -> void:
	super()
	print("flee attempt")
	var flee_chance : float = 0.5
	if randf() < flee_chance:
		if tb_fight_root:
			print("battler fled")
			tb_fight_root.end_fight_after_action = true
			tb_fight_root.player_fled = true
