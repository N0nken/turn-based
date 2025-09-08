extends Node

signal input_method_changed(to_keyboard : bool)

var using_keyboard_icons := true
var ui_keyboard_icons : AtlasTexture = AtlasTexture.new()
var ui_controller_icons : AtlasTexture = AtlasTexture.new()
var ui_controller_icons_positions : Dictionary[String, Vector2] = {
	
}
var ui_keyboard_icons_positions : Dictionary[String, Vector2] = {
	
}

func _ready() -> void:
	ui_keyboard_icons.atlas = preload(Filepaths.UI_INPUT_ICONS["keyboard"])
	ui_keyboard_icons.region = Rect2(0,0,16,16)
	ui_controller_icons.atlas = preload(Filepaths.UI_INPUT_ICONS["controller"])
	ui_controller_icons.region = Rect2(0,0,16,16)


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		if not using_keyboard_icons:
			input_method_changed.emit(true)
			using_keyboard_icons = true
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if using_keyboard_icons:
			input_method_changed.emit(false)
			using_keyboard_icons = false


func get_active_ui_icon_atlas() -> AtlasTexture:
	if using_keyboard_icons:
		return ui_keyboard_icons.duplicate()
	return ui_controller_icons.duplicate()
