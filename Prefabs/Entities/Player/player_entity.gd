class_name PlayerEntity
extends Entity

@export var sprint_multiplier := 1.0

var input_enabled := true


func _physics_process(delta: float) -> void:
	if input_enabled:
		var input_dir := Input.get_axis("move_left", "move_right")
		movement_speed = base_speed
		if Input.is_action_pressed("run"):
			movement_speed *= sprint_multiplier
		movement_direction = Vector2(input_dir, 0)
	else:
		movement_direction = Vector2.ZERO
	super(delta)
