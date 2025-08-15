class_name TB_FightMoveListItem
extends Control

signal pressed(action : TB_Action)

var action : TB_Action = null

func _ready() -> void:
	get_node("MarginContainer/HBoxContainer/TBFightMoveIcon").set_icon(action.icon)
	get_node("MarginContainer/HBoxContainer/MoveName").text = action.action_name

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		pressed.emit(action)
