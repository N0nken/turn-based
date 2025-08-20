extends Node

func _ready() -> void:
	if not FileAccess.file_exists(Filepaths.TOTALLY_SUPER_IMPORTANT_COCONUT_PNG_DO_NOT_REMOVE):
		get_tree().quit()
