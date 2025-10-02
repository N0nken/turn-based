class_name ActionIcon
extends Button


func set_icon(input_icon : Texture2D) -> void:
	if input_icon == null:
		icon = load("res://Assets/Images/TB Action Icons/16x16_texture_not_found.png")
	else:
		icon = input_icon
	
