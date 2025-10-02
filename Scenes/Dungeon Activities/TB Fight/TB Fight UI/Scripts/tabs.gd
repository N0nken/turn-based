extends MarginContainer

@export var _player_confirm_button : Button
@export var _player_battler : TB_PlayerBattler

@onready var _moves_container : VActionContainer = get_node("Moves/ScrollContainer/VActionContainer")
@onready var _items_container : VActionContainer = get_node("Items/ScrollContainer/VActionContainer")


func setup() -> void:
	load_action_set(_player_battler.weapon.move_set, _moves_container)
	load_action_set(_player_battler.backpack, _items_container)


func load_action_set(action_set : Array, container : VActionContainer) -> void:
	if action_set.size() == 0:
		return
	
	container.load_action_set(action_set)
	
	for i in range(0, container.get_child_count()):
		var action_list_item : TB_ActionListItem = container.get_child(i)
		action_list_item.pressed.connect(_on_action_list_item_pressed.bind(action_set[i]))
		if i == 0:
			action_list_item.grab_focus()
		elif i == container.get_child_count() - 1:
			action_list_item.focus_neighbor_bottom = _player_confirm_button.get_path()


func _on_action_list_item_pressed(action : TB_Action) -> void:
	_player_battler.plan_action(action)
