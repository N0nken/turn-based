extends Node2D


func _on_main_menu_button_pressed() -> void:
	LoadedRun.reset()
	SceneManager.next_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
