class_name InfoBox
extends Control

const SCROLL_SPEED := 500

@export var header_template := ""

@onready var description_v_scroll_bar : VScrollBar = get_node("Description").get_v_scroll_bar()

func _process(delta: float) -> void:
	_scroll_handler(delta)


func update_header(icon : Texture2D, action_name : String) -> void:
	if icon == null:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)
	get_node("Header").text = action_name
	get_node("Icon/MarginContainer/TextureRect").texture = icon


func update_description(description : String) -> void:
	get_node("Description").text = description

## [param icon]: 16x16 icon[br]
## [param header]: item name[br]
## [param description]: item description
func update_info(icon : Texture2D, header : String, description : String) -> void:
	update_header(icon, header)
	update_description(description)


func _scroll_handler(delta : float) -> void:
	var scroll_direction := Input.get_axis("info_box_scroll_up", "info_box_scroll_down")
	if scroll_direction != 0:
		description_v_scroll_bar.value += description_v_scroll_bar.step * SCROLL_SPEED * delta * scroll_direction
