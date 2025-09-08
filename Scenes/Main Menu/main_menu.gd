extends Node2D


func _ready() -> void:
	get_node("UI/Control/CenterContainer/VBoxContainer/StartButton").grab_focus()


func _on_start_button_pressed() -> void:
	SceneManager.next_scene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
