extends Control

@export var head_node : TB_Fight = null

func _on_pressed() -> void:
	head_node.get_node("Battlers/TBPlayer").finish_planning()
