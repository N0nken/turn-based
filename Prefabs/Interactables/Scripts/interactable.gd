class_name Interactable
extends Node2D

signal interacted

@export var interaction_name := ""
@export var interaction_manager : InteractionManager = null
@export var hitbox : InteractableArea = null
@export var sprite : Sprite2D = null
@export var highlight_on_player_nearby := false
@export var label_position : Node2D = null


func _ready() -> void:
	hitbox.player_entered.connect(_on_player_entered)
	hitbox.player_exited.connect(_on_player_exited)
	self.interacted.connect(_on_player_interacted)


func _on_player_entered() -> void:
	interaction_manager.register_interactable(self)


func _on_player_exited() -> void:
	interaction_manager.deregister_interactable(self)


func activate_highlight() -> void:
	if sprite and highlight_on_player_nearby:
		sprite.material.set_shader_parameter("enabled", true)


func deactivate_highlight() -> void:
	if sprite and highlight_on_player_nearby:
		sprite.material.set_shader_parameter("enabled", false)


func _on_player_interacted() -> void:
	pass
	#prints("Interacted with", self.name)
