extends Control

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		get_tree().root.get_node("TBFight/Battlers/TBPlayer").finish_planning()
