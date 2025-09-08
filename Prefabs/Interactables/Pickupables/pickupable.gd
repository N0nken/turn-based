class_name Pickupable
extends Interactable

signal picked_up
signal placed

var is_picked_up := false
var grabber : Entity = null


func _on_player_interacted() -> void:
	is_picked_up = true
	grabber = get_tree().get_first_node_in_group("Player")
