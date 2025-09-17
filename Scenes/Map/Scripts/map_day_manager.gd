class_name MapDayManager
extends Node

@export var time_active := false
@export_range(0, 24) var start_time := 0
## Every IRL second corresponds to [param time_scale] in game seconds.
@export var time_scale := 1.0
@export var darkness_scale : float = 0.5
@export var light_arc : Curve
@export var brightness_curve : Curve
@export var hue_controller : Gradient
@export var shader_map : ColorRect
@export var time_debug_node : Label

var time := 0.0

@onready var light_node : DirectionalLight2D = get_node("Light")
@onready var dark_node : DirectionalLight2D = get_node("Dark")


func _ready() -> void:
	time = start_time / 24.0
	set_time(time)


func _process(delta: float) -> void:
	if time_active:
		set_time(time)
		time = (time + delta / time_scale)
		if time >= 1.0:
			time = 0.0


## [param progress] = range(0.0 - 1.0)
func set_time(progress : float) -> void:
	
	var ext_darkness_scale = get_parent().map_presets[get_parent().map_biome].darkness_scale * 2
	var brightness = brightness_curve.sample(progress)
	var rotation = -light_arc.sample(progress)
	light_node.rotation = rotation
	light_node.color = hue_controller.sample(brightness)
	dark_node.rotation = rotation
	dark_node.energy = (brightness_curve.max_value - brightness) * darkness_scale * ext_darkness_scale
	time_debug_node.text = str(progress)
