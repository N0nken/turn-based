extends Node

@export var dungeon_template : DungeonTemplate = null

var template_loading_thread := Thread.new()

@onready var dungeon_tree : DungeonTree = get_node("DungeonTree")

func _ready() -> void:
	dungeon_template = LoadedRun.active_dungeon_template
	#template_loading_thread.start(load.bind(Filepaths.DUNGEON_TEMPLATES[dungeon_template_name]))
	#dungeon_template = await template_loading_thread.wait_to_finish()
	dungeon_tree.generate_dungeon(dungeon_template)


func _on_dungeon_tree_dungeon_cleared() -> void:
	LoadedRun.clear_active_dungeon()
	SceneManager.next_scene(0) # Success continue to upgrade/map scene


func _on_dungeon_activity_manager_activity_ended(node: DungeonNode) -> void:
	if LoadedRun.player.health <= 0:
		SceneManager.next_scene(1) # Fail continue to end scene
		return
	dungeon_tree.visible = true
	dungeon_tree.next_node(node)
