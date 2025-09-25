class_name Equipment
extends Resource

@export_range(1, 99) var level := 1
@export var equipment_name := ""
@export var icon : Texture2D
@export_multiline var description := ""

func get_description() -> String:
	return description + "\n\n" + _get_stringified_stats()


func _get_stringified_stats() -> String:
	return "Lvl: " + str(level)
