class_name DungeonNode
extends Control

signal activity_selected(target_activity : String)

@export var node_template : DungeonNodeTemplate = null
@export var target_camera : Camera2D = null

var branches : Array[DungeonNode] = []
var depth := 0
var parents : Array[DungeonNode] = []
var parent_connections : Array[Line2D] = []
var cleared := false
var locked := false
var icon_container_previous_modulate = null

func _ready() -> void:
	update_icon()
	self.deactivate()


func _on_button_pressed() -> void:
	activity_selected.emit(node_template.target_activity_name, self)


func update_icon() -> void:
	if node_template:
		if node_template.icon:
			get_node("Icon").texture = node_template.icon
		else:
			get_node("Icon").texture = load(Filepaths.TEXTURE_NOT_FOUND)
	else:
		get_node("Icon").texture = load(Filepaths.TEXTURE_NOT_FOUND)


func _on_button_focus_entered() -> void:
	target_camera.global_position = self.global_position
	icon_container_previous_modulate = get_node("IconContainer").self_modulate
	get_node("IconContainer").self_modulate = Color("FFFFFF")


func activate() -> void:
	get_node("Button").disabled = false
	get_node("Icon").self_modulate = Color("FFFFFF")
	get_node("IconContainer").self_modulate = Color("00FF00")
	for connection in parent_connections:
		if connection.parent.cleared:
			connection.self_modulate = Color("FFFFFF")


func deactivate() -> void:
	get_node("Button").disabled = true
	get_node("Icon").self_modulate = Color("ffffff")
	get_node("IconContainer").self_modulate = Color("888888")
	for connection in parent_connections:
		#if connection.parent.cleared:
		connection.self_modulate = Color("888888")


func activate_children() -> void:
	for child in branches:
		child.activate()


func deactivate_children() -> void:
	for child in branches:
		child.deactivate()


func lock() -> void:
	self.deactivate()
	get_node("Locked").visible = true
	locked = true


func clear() -> void:
	self.deactivate()
	get_node("Cleared").visible = true
	cleared = true


func _on_button_focus_exited() -> void:
	get_node("IconContainer").self_modulate = icon_container_previous_modulate
