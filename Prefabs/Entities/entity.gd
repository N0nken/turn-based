class_name Entity
extends CharacterBody2D

@export var base_speed := 0.0
@export var acceleration := 1.0
var movement_speed := 0.0
var movement_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var lerp_direction := movement_direction - velocity
	var lerped_velocity := velocity.lerp(movement_direction * movement_speed, delta * acceleration)
	if lerp_direction.x < 0:
		lerped_velocity = clamp(lerped_velocity, movement_direction * movement_speed, Vector2.ZERO)
	velocity = movement_direction * movement_speed
	move_and_slide()
