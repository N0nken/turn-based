class_name Interactable
extends Node2D

signal interacted

@export var hitbox : InteractableHitbox = null

var player_in_range := false
var player_hitbox : InteractableHitbox = null
var distance_to_player := 0.0

func _ready() -> void:
	hitbox.hitbox_detected.connect(_on_hitbox_detected)


func _physics_process(delta: float) -> void:
	if player_in_range:
		distance_to_player = self.global_position.distance_to(player_hitbox.global_position)


func _on_hitbox_detected(hitbox : InteractableHitbox) -> void:
	player_in_range = true
	player_hitbox = hitbox
