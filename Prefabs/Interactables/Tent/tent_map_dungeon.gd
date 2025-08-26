class_name TentMapDungeon
extends Button

var total_dungeon_count := 3
var dungeon_index := 0
var dungeon_position_x_offset := Vector2i(5, 5)
var graph_offset := randi_range(0, 50)

func _ready() -> void:
	pass
	#self.position -= Vector2(50, 50)
