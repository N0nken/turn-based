class_name InteractionManager
extends Node

@export var player : PlayerEntity = null
@export var interaction_label_collection : Control = null

var active_interactables : Array[Interactable] = []
var selected_interactable : Interactable = null
var ss_input_icons := preload(Filepaths.SS_INPUT_ICONS)

@onready var unified_label_position: Node2D = $UnifiedLabelPosition


func register_interactable(interactable : Interactable) -> void:
	if interactable in active_interactables:
		return
	active_interactables.append(interactable)
	if active_interactables.size() == 1:
		selected_interactable = interactable
		interactable.activate_highlight()


func deregister_interactable(interactable : Interactable) -> void:
	var index := active_interactables.find(interactable)
	if index == -1:
		return
	active_interactables.remove_at(index)
	if active_interactables.size() == 1:
		active_interactables[0].activate_highlight()
		selected_interactable = active_interactables[0]
	interactable.deactivate_highlight()


func _process(_delta: float) -> void:
	if active_interactables.size() > 0:
		var target_interactable : Interactable = active_interactables[0]
		var x := 0
		var y := 0
		var region := Rect2(x,y,8,8)
		interaction_label_collection.get_node("HBoxContainer/TextureRect").texture = ImageTexture.create_from_image(Commons.texture2d_get_region(ss_input_icons, region))
		interaction_label_collection.get_node("HBoxContainer/Label").text = target_interactable.interaction_name
		interaction_label_collection.global_position = target_interactable.label_position.global_position - Vector2(interaction_label_collection.size.x / 2, interaction_label_collection.size.y / 2)
		interaction_label_collection.show()
	else:
		interaction_label_collection.hide()


func _physics_process(_delta: float) -> void:
	if active_interactables.size() > 1:
		var previous_first_area := active_interactables[0]
		active_interactables.sort_custom(sort_by_distance_to_player)
		if active_interactables[0] != previous_first_area:
			active_interactables[0].activate_highlight()
			selected_interactable = active_interactables[0]
			previous_first_area.deactivate_highlight()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and selected_interactable:
		selected_interactable.interacted.emit()


func sort_by_distance_to_player(interactable1 : Interactable, interactable2 : Interactable) -> bool:
	var dist1 := interactable1.global_position.distance_to(player.global_position)
	var dist2 := interactable2.global_position.distance_to(player.global_position)
	return dist1 < dist2
