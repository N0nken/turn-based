extends HBoxContainer

@export var shop_tab : Control
@export var inventory_tab : Control

var active_tab : Control = null

@onready var shop_button : Button = get_node("Shop")
@onready var inventory_button : Button = get_node("Inventory")


func _ready() -> void:
	active_tab = shop_tab
	shop_button.disabled = true
	inventory_button.disabled = false
	shop_tab.visible = true
	inventory_tab.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu_left"):
		_change_tab(shop_tab)
	elif event.is_action_pressed("ui_menu_right"):
		_change_tab(inventory_tab)


func _change_tab(to : Control) -> void:
	if to == active_tab:
		return
	active_tab.visible = false
	to.visible = true
	active_tab = to
	if to == shop_tab:
		shop_button.disabled = true
		inventory_button.disabled = false
		shop_tab.get_node("VBoxContainer/ShopItems/EquipmentForSale/ShopListItem").grab_focus()
	elif to == inventory_tab:
		shop_button.disabled = false
		inventory_button.disabled = true
	


func _on_shop_pressed() -> void:
	_change_tab(shop_tab)


func _on_inventory_pressed() -> void:
	_change_tab(inventory_tab)
