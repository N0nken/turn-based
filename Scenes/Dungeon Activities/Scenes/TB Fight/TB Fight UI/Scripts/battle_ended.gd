class_name TB_BattleEnded
extends Control


func show_player_won(gold_drop : int) -> void:
	get_node("CenterContainer/Panel/BattleResult").text = "Battle Won!"
	get_node("CenterContainer/Panel/GoldGain").text = "gold: " + str(gold_drop)
	get_node("../Control/PlannedMoves/Enemy/Icon/MarginContainer/MarginContainer/Dead").visible = true
	self.visible = true


func show_player_lost() -> void:
	get_node("CenterContainer/Panel/BattleResult").text = "Battle Lost!"
	get_node("CenterContainer/Panel/GoldGain").text = "gold: 0"
	get_node("../Control/PlannedMoves/Player/Icon/MarginContainer/MarginContainer/Dead").visible = true
	self.visible = true
