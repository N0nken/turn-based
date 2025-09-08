class_name TB_FightMoveListItem
extends Control

signal pressed(action : TB_Action)

var action : TB_Action = null

func _ready() -> void:
	if action.icon:
		get_node("Button").icon = action.icon
	else:
		get_node("Button").icon = load(Filepaths.TEXTURE_NOT_FOUND)
	get_node("Button").text = action.action_name


func _on_button_pressed() -> void:
	pressed.emit(action)
