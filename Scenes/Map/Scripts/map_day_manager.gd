class_name MapDayManager
extends Node

@export var shader_map : ColorRect
@export var light_node : DirectionalLight2D
@export var light_arc : Curve
@export var shadow_limit : Curve
@export var hue_controller : Gradient
@export var start_time := 0.0
## Every IRL second corresponds to [param time_scale] in game seconds.
@export var time_scale := 1.0

var time := 0.0


func _ready() -> void:
	set_time(0.0)


func _process(delta: float) -> void:
	set_time(time)
	time = (time + delta / time_scale )
	if time >= 1.0:
		time = 0.0



## [param progress] = range(0.0 - 1.0)
func set_time(progress : float) -> void:
	light_node.rotation = light_arc.sample(progress)
	light_node.color = hue_controller.sample(progress)
	shader_map.material.set_shader_parameter("shadow_limit", shadow_limit.sample(progress))
