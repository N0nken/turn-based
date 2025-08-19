extends Node

@export var dungeon_template : DungeonTemplate = null

func _ready() -> void:
	var dungeon_tree : DungeonTree = get_node("DungeonTree")
	dungeon_tree.generate_dungeon(dungeon_template)
