class_name DungeonShop
extends DungeonActivity

const EQUIPMENT_FOR_SALE_COUNT := 3
const ITEMS_FOR_SALE_COUNT := 3

var equipment_for_sale : Array[Equipment] = []
var items_for_sale : Array[TB_Item] = []
var latest_selected_item : ShopListItem = null

@onready var equipment_for_sale_container : HBoxContainer = get_node("UI/Control/MarginContainer/HBoxContainer/Left/TabContainer/ShopTab/VBoxContainer/ShopItems/EquipmentForSale")
@onready var items_for_sale_container : HBoxContainer = get_node("UI/Control/MarginContainer/HBoxContainer/Left/TabContainer/ShopTab/VBoxContainer/ShopItems/ItemsForSale")
@onready var info_box : InfoBox = get_node("UI/Control/MarginContainer/HBoxContainer/Right/InfoBox")
@onready var move_set_container : HBoxContainer = get_node("UI/Control/MarginContainer/HBoxContainer/Left/TabContainer/ShopTab/VBoxContainer/SelectedItemMoveSet")
@onready var buy_button : BuyButton = get_node("UI/Control/MarginContainer/HBoxContainer/Right/HBoxContainer/Buy")
@onready var player_gold_label : Label = get_node("UI/Control/MarginContainer/HBoxContainer/Left/Gold")
@onready var tab_bar : HBoxContainer = get_node("UI/Control/MarginContainer/HBoxContainer/Left/TabBar")


func _ready() -> void:
	setup()


## Generate equipment and items for sale
func setup() -> void:
	player_gold_label.text = str(LoadedRun.player.gold)
	
	# Copies of possible equipment to remove already selected equipment to avoid duplicate equipment for sale
	var available_armor : Array[Armor] = LoadedRun.active_dungeon_template.armor_for_sale.duplicate()
	var available_weapons : Array[Weapon] = LoadedRun.active_dungeon_template.weapons_for_sale.duplicate()
	
	# Generate equipment for sale. 50% chance equipment is armor, 50% chance equipment is weapon. 
	# Guaranteed equipment if theres equipment left to sell.
	for i in range(0, EQUIPMENT_FOR_SALE_COUNT):
		if randf() > 0.5 and available_armor.size() > 0:
			_pick_equipment_from_set(available_armor)
		elif available_weapons.size() > 0:
			_pick_equipment_from_set(available_weapons)
		elif available_armor.size() > 0:
			_pick_equipment_from_set(available_armor)
		else:
			continue
		var shop_list_item : ShopListItem = equipment_for_sale_container.get_child(i)
		shop_list_item.setup_equipment(equipment_for_sale[i])
		shop_list_item.pressed.connect(_on_shop_list_equipment_pressed.bind(equipment_for_sale[i], shop_list_item))
	
	# Load first equipment to replace placeholder contents of info_box
	equipment_for_sale_container.get_child(0).grab_focus()
	_on_shop_list_equipment_pressed(equipment_for_sale[0], equipment_for_sale_container.get_child(0))
	
	# Generate items for sale
	for i in range(0, ITEMS_FOR_SALE_COUNT):
		items_for_sale.append(LoadedRun.active_dungeon_template.items_for_sale.pick_random())
		var shop_list_item : ShopListItem = items_for_sale_container.get_child(i)
		shop_list_item.setup_item(items_for_sale[i])
		shop_list_item.pressed.connect(_on_shop_list_item_pressed.bind(items_for_sale[i], shop_list_item))

	# Correct focus neighbors
	# Equipment
	equipment_for_sale_container.get_child(0).focus_neighbor_right = equipment_for_sale_container.get_child(1).get_path()
	equipment_for_sale_container.get_child(1).focus_neighbor_left = equipment_for_sale_container.get_child(0).get_path()
	equipment_for_sale_container.get_child(1).focus_neighbor_right = equipment_for_sale_container.get_child(2).get_path()
	equipment_for_sale_container.get_child(2).focus_neighbor_left = equipment_for_sale_container.get_child(1).get_path()
	
	# Items
	items_for_sale_container.get_child(0).focus_neighbor_right = items_for_sale_container.get_child(1).get_path()
	items_for_sale_container.get_child(1).focus_neighbor_left = items_for_sale_container.get_child(0).get_path()
	items_for_sale_container.get_child(1).focus_neighbor_right = items_for_sale_container.get_child(2).get_path()
	items_for_sale_container.get_child(2).focus_neighbor_left = items_for_sale_container.get_child(1).get_path()


## Helper function to generate equipment for sale
func _pick_equipment_from_set(equipment_set : Array) -> void:
	equipment_for_sale.append(equipment_set.pop_at(randi_range(0, equipment_set.size() - 1)))


## Update info box on equipment selected
func _on_shop_list_equipment_pressed(equipment : Equipment, shop_item : ShopListItem) -> void:
	info_box.update_info(equipment.icon, equipment.equipment_name, equipment.get_description())
	_update_shop_after_item(shop_item, equipment.shop_price)
	
	if equipment is Weapon:
		_load_move_set(equipment.move_set)


## Update info box on item selected
func _on_shop_list_item_pressed(item : TB_Item, shop_item : ShopListItem) -> void:
	info_box.update_info(item.icon, item.action_name, item.description)
	_update_shop_after_item(shop_item, item.shop_price)


func _update_shop_after_item(shop_item : ShopListItem, price : int) -> void:
	_clear_move_set()
	_clear_shop_list_item_backgrounds()
	shop_item.activate_background()
	buy_button.set_price(price)
	latest_selected_item = shop_item


func _on_action_icon_pressed(action : TB_Action) -> void:
	info_box.update_info(action.icon, action.action_name, action.description)


func _load_move_set(move_set : Array[TB_Move]) -> void:
	move_set_container.get_child(0).visible = true
	for i in range(move_set.size()):
		var action_icon : ActionIcon = move_set_container.get_child(1+i)
		var move : TB_Move = move_set[i]
		action_icon.set_icon(move.icon)
		action_icon.visible = true
		if action_icon.pressed.is_connected(_on_action_icon_pressed):
			continue
		action_icon.pressed.connect(_on_action_icon_pressed.bind(move))


func _clear_move_set() -> void:
	for node in move_set_container.get_children():
		node.visible = false


## Deactivate backgrounds and highlight selected shop items
func _clear_shop_list_item_backgrounds() -> void:
	for node in equipment_for_sale_container.get_children():
		node.deactivate_background()
	
	for node in items_for_sale_container.get_children():
		node.deactivate_background()


func _on_buy_pressed() -> void:
	if not latest_selected_item:
		return
	var price := 0
	
	if latest_selected_item.registered_equipment != null:
		var equipment_bought : Equipment = latest_selected_item.registered_equipment
		price = equipment_bought.shop_price
		var old_equipment : Equipment
		# Replace old equipment in player inventory
		if equipment_bought is Weapon:
			old_equipment = LoadedRun.player.tb_template.weapon
			LoadedRun.player.tb_template.weapon = equipment_bought
		else:
			old_equipment = LoadedRun.player.tb_template.armor
			LoadedRun.player.tb_template.armor = equipment_bought
		# Put old equipment into shop item slot
		latest_selected_item.registered_equipment = old_equipment
		
	elif latest_selected_item:
		var item_bought : TB_Item = latest_selected_item.registered_item
		price = item_bought.shop_price
		var item_found_in_backpack := false
		for item in LoadedRun.player.backpack:
			if item_bought == item:
				item.count += 1
				item_found_in_backpack = true
		if not item_found_in_backpack:
			LoadedRun.player.backpack.append(item_bought)
		
	LoadedRun.player.gold -= price
	player_gold_label.text = str(LoadedRun.player.gold)
	prints(latest_selected_item.registered_equipment.equipment_name, latest_selected_item.registered_item, "bought")


func _on_continue_pressed() -> void:
	activity_ended.emit()
