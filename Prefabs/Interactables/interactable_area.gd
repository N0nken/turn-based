class_name InteractableArea
extends Area2D

@export var interaction_manager : InteractionManager = null
@export var interaction_name := ""
@export var sprite : Sprite2D = null

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerEntity:
		interaction_manager.register_area(self)
		


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerEntity:
		interaction_manager.deregister_area(self)
		deactivate_highlight()


func activate_highlight() -> void:
	if sprite:
		sprite.material.set_shader_parameter("enabled", true)


func deactivate_highlight() -> void:
	if sprite:
		sprite.material.set_shader_parameter("enabled", false)
