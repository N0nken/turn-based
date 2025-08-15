extends Control

var active_tab = "Moves"

func _ready() -> void:
	get_node("MarginContainer/HBoxContainer/Moves").grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu_left"):
		if active_tab == "Moves":
			_change_tab("Items")
		elif active_tab == "Items":
			_change_tab("Moves")
	elif event.is_action_pressed("ui_menu_right"):
		if active_tab == "Moves":
			_change_tab("Items")
		elif active_tab == "Items":
			_change_tab("Moves")


func _on_moves_pressed() -> void:
	_change_tab("Moves")


func _on_items_pressed() -> void:
	_change_tab("Items")


func _change_tab(to : String) -> void:
	if to == "Items":
		active_tab = to
		get_node("../Tabs/Moves").visible = false
		get_node("../Tabs/Items").visible = true
		get_node("MarginContainer/HBoxContainer/Moves").disabled = false
		get_node("MarginContainer/HBoxContainer/Items").disabled = true
	elif to == "Moves":
		active_tab = to
		get_node("../Tabs/Moves").visible = true
		get_node("../Tabs/Items").visible = false
		get_node("MarginContainer/HBoxContainer/Moves").disabled = true
		get_node("MarginContainer/HBoxContainer/Items").disabled = false
