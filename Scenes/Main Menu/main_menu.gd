extends Node2D

var packed_map_scene := preload(Filepaths.SCENES["map"])


func _physics_process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(packed_map_scene)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
