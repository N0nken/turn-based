class_name DungeonShop
extends DungeonActivity


var _armor_for_sale : Armor
var _weapon_for_sale : Weapon

@onready var _player_entity : PlayerEntity = get_node("PlayerEntity")


func _ready() -> void:
	setup()


func setup() -> void:
	_armor_for_sale = LoadedRun.active_dungeon_template.faction.armor_for_sale.pick_random()
	_weapon_for_sale = LoadedRun.active_dungeon_template.faction.weapons_for_sale.pick_random()


func _on_armor_interactable_interacted() -> void:
	if not _armor_for_sale:
		return
	get_node("UI/Control/ItemComparison").update_comparison(_armor_for_sale)
	get_node("UI/Control/ItemComparison").visible = true
	_player_entity.input_enabled = false


func _on_weapon_interactable_interacted() -> void:
	if not _weapon_for_sale:
		return
	get_node("UI/Control/ItemComparison").update_comparison(_weapon_for_sale)
	get_node("UI/Control/ItemComparison").visible = true
	_player_entity.input_enabled = false


func _on_item_comparison_comparison_closed() -> void:
	_player_entity.input_enabled = true
