class_name Equipment
extends Resource

@export_range(1, 99) var level := 1
@export var equipment_name := ""
@export var icon : Texture2D
@export var shop_icon : Texture2D
@export var shop_price : int
@export_multiline var _description := ""

func get_description() -> String:
	return _description + "\n\n" + _get_stringified_stats()


func _get_stringified_stats() -> String:
	return "Lvl: " + str(level)
