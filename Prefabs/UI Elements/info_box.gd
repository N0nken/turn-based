class_name InfoBox
extends Control

@export var header_template := ""


func update_header(icon : Texture2D, action_name : String) -> void:
	if icon == null:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)
	get_node("Header").text = action_name
	get_node("Icon/MarginContainer/TextureRect").texture = icon


func update_description(description : String) -> void:
	get_node("Description").text = description


func update_info(icon : Texture2D, header : String, description : String) -> void:
	update_header(icon, header)
	update_description(description)
