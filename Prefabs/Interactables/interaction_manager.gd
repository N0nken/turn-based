class_name InteractionManager
extends Node

@export var player : PlayerEntity = null
@export var interaction_label := Label.new()

var active_areas : Array[InteractableArea] = []

func register_area(area : InteractableArea) -> void:
	if area in active_areas:
		return
	active_areas.append(area)
	if active_areas.size() == 1:
		area.activate_highlight()


func deregister_area(area : InteractableArea) -> void:
	var index := active_areas.find(area)
	if index == -1:
		return
	active_areas.remove_at(index)
	if active_areas.size() == 1:
		active_areas[0].activate_highlight()


func _process(_delta: float) -> void:
	if active_areas.size() > 0:
		var target_area : InteractableArea = active_areas[0]
		interaction_label.text = "[E] " + target_area.interaction_name
		interaction_label.global_position = target_area.get_node("InteractLabelPosition").global_position - Vector2(interaction_label.size.x / 2, 0)
		interaction_label.show()
	else:
		interaction_label.hide()


func _physics_process(_delta: float) -> void:
	if active_areas.size() > 1:
		var previous_first_area := active_areas[0]
		active_areas.sort_custom(sort_by_distance_to_player)
		if active_areas[0] != previous_first_area:
			active_areas[0].activate_highlight()
			previous_first_area.deactivate_highlight()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		pass


func sort_by_distance_to_player(area1 : InteractableArea, area2 : InteractableArea) -> bool:
	var dist1 := area1.global_position.distance_to(player.global_position)
	var dist2 := area2.global_position.distance_to(player.global_position)
	return dist1 < dist2
