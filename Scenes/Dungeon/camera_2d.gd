extends Camera2D

@export var camera_speed := 0

func _process(delta : float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	self.position += direction * camera_speed * delta
