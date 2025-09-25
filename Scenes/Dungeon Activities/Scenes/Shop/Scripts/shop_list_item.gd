class_name ShopListItem
extends Button

var registered_equipment : Equipment

func setup(equipment : Equipment) -> void:
	registered_equipment = equipment
	if equipment.icon:
		icon = equipment.icon
	else:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)
	text = equipment.equipment_name
