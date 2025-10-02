class_name ShopListItem
extends Button

var registered_equipment : Equipment
var registered_item : TB_Item


func setup_equipment(equipment : Equipment) -> void:
	registered_equipment = equipment
	if equipment.shop_icon:
		icon = equipment.shop_icon
	else:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)


func setup_item(item : TB_Item) -> void:
	registered_item = item
	if item.shop_icon:
		icon = item.shop_icon
	else:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)


func activate_background() -> void:
	get_node("Panel").visible = true


func deactivate_background() -> void:
	get_node("Panel").visible = false
