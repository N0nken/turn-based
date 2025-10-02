extends Control

@export var keyboard_icons : AtlasTexture = null
@export var controller_icons : AtlasTexture = null

var active_tab = "Moves"

@onready var moves_button : Button = get_node("MarginContainer/HBoxContainer/Moves")
@onready var items_button : Button = get_node("MarginContainer/HBoxContainer/Items")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu_left"):
		_change_tab("Moves")
	elif event.is_action_pressed("ui_menu_right"):
		_change_tab("Items")


func _on_moves_pressed() -> void:
	_change_tab("Moves")


func _on_items_pressed() -> void:
	_change_tab("Items")


func _change_tab(to : String) -> void:
	var actions_container : VBoxContainer = null
	if to == "Items":
		active_tab = to
		get_node("../Tabs/Moves").visible = false
		get_node("../Tabs/Items").visible = true
		moves_button.disabled = false
		items_button.disabled = true
		actions_container = get_node("../Tabs/Items/ScrollContainer/VBoxContainer")
	elif to == "Moves":
		active_tab = to
		get_node("../Tabs/Moves").visible = true
		get_node("../Tabs/Items").visible = false
		moves_button.disabled = true
		items_button.disabled = false
		actions_container = get_node("../Tabs/Moves/ScrollContainer/VBoxContainer")
	if !actions_container:
		return
	if actions_container.get_child_count() == 0:
		return
	var first_action : Button = actions_container.get_child(0)
	first_action.grab_focus()
