class_name DungeonActivityManager
extends Node

signal activity_started
signal activity_ended(node : DungeonNode)

var latest_node : DungeonNode = null

func _start_activity(activity : String, parent : DungeonNode) -> void:
	parent.activate_children()
	for grandparent in parent.parents:
		grandparent.deactivate_children()
	var packed_activity : PackedScene = load(Filepaths.DUNGEON_ACTIVITES[activity])
	var instanced_activity := packed_activity.instantiate()
	instanced_activity.activity_ended.connect(_on_activity_ended)
	get_node("Container").add_child(instanced_activity)


func _on_activity_selected(activity_name : String, parent : DungeonNode) -> void:
	print(activity_name, " selected")
	_start_activity(activity_name, parent)
	latest_node = parent
	get_node("Container").get_child(0).camera.make_current()
	activity_started.emit()


func _on_activity_ended() -> void:
	latest_node.clear()
	activity_ended.emit(latest_node)
