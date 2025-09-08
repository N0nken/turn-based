class_name TB_FightMoveIcon
extends Panel

func set_icon(icon : Texture2D) -> void:
	if icon == null:
		get_node("MarginContainer/CenterContainer/TextureRect").texture = load("res://Assets/Images/TB Action Icons/16x16_texture_not_found.png")
	else:
		get_node("MarginContainer/CenterContainer/TextureRect").texture = icon
	
