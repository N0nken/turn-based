class_name TentUI
extends Control

@export var shader_map : ColorRect = null

func _ready() -> void:
	if shader_map:
		var noise_texture : NoiseTexture2D = shader_map.material.get_shader_parameter("noise")
		noise_texture.noise.seed = randi()
		shader_map.material.set_shader_parameter("noise", noise_texture)
