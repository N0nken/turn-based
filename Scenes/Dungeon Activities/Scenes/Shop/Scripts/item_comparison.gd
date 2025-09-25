extends Control

signal item_bought
signal comparison_closed

var equipment_is_armor := true

var buy_start_timestamp := 0
var buy_confirm_delay := 1000 # msec


func update_comparison(equipment : Equipment) -> void:
	get_node("HBoxContainer/VBoxContainer/ShopItem").setup(equipment)
	get_node("HBoxContainer/VBoxContainer/ShopItem").grab_focus()
	if equipment is Weapon:
		equipment_is_armor = false
		get_node("HBoxContainer/VBoxContainer/shop_move_container").load_move_set(equipment)
		get_node("HBoxContainer/VBoxContainer/equipped_move_container").load_move_set(LoadedRun.player.tb_template.weapon)
		get_node("HBoxContainer/VBoxContainer/EquippedItem").setup(LoadedRun.player.tb_template.weapon)
	else:
		equipment_is_armor = true
		get_node("HBoxContainer/VBoxContainer/EquippedItem").setup(LoadedRun.player.tb_template.armor)
	get_node("HBoxContainer/InfoBox").update_info(equipment.icon, equipment.equipment_name, equipment.description)


func _close_comparison() -> void:
	self.visible = false
	get_node("HBoxContainer/VBoxContainer/shop_move_container").clear_move_set()
	get_node("HBoxContainer/VBoxContainer/equipped_move_container").clear_move_set()
	comparison_closed.emit()


func _on_close_pressed() -> void:
	_close_comparison()


func _on_button_button_down() -> void:
	buy_start_timestamp = Time.get_ticks_msec()


func _on_button_button_up() -> void:
	if Time.get_ticks_msec() - buy_start_timestamp > buy_confirm_delay:
		_close_comparison()
		item_bought.emit()


func _on_shop_item_pressed() -> void:
	if not equipment_is_armor:
		get_node("HBoxContainer/VBoxContainer/shop_move_container").visible = true


func _on_equipped_item_pressed() -> void:
	if not equipment_is_armor:
		get_node("HBoxContainer/VBoxContainer/equipped_move_container").visible = true
