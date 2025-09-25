extends MarginContainer

@export var _player_confirm_button : Button
@export var _player_battler : TB_PlayerBattler

var _action_list_item : PackedScene = preload(Filepaths.TB_FIGHT_UI_NODES.move_list_item)

@onready var _moves_container : VBoxContainer = get_node("Moves/ScrollContainer/VBoxContainer")
@onready var _items_container : VBoxContainer = get_node("Items/ScrollContainer/VBoxContainer")


func setup() -> void:
	load_action_set(_player_battler.weapon.move_set, _moves_container)
	load_action_set(_player_battler.backpack, _items_container)


func load_action_set(action_set : Array, container : VBoxContainer) -> void:
	if action_set.size() == 0:
		return
	var first_list_item : TB_ActionListItem = _action_list_item.instantiate()
	first_list_item.action = action_set[0]
	container.add_child(first_list_item)
	first_list_item.pressed.connect(_on_action_list_item_pressed.bind(action_set[0]))
	first_list_item.grab_focus()

	if action_set.size() == 1:
		return
	for i in range(1, action_set.size() - 1):
		var next_list_item : TB_ActionListItem = _action_list_item.instantiate()
		next_list_item.action = action_set[i]
		container.add_child(next_list_item)
		next_list_item.pressed.connect(_on_action_list_item_pressed.bind(action_set[i]))
		
		next_list_item.focus_neighbor_top = container.get_child(i-1).get_path()
		container.get_child(i-1).focus_neighbor_bottom = next_list_item.get_path()

	var last_list_item : TB_ActionListItem = _action_list_item.instantiate()
	last_list_item.action = action_set[-1]
	container.add_child(last_list_item)
	last_list_item.pressed.connect(_on_action_list_item_pressed.bind(action_set[-1]))
	
	last_list_item.focus_neighbor_top = container.get_child(-2).get_path()
	container.get_child(-2).focus_neighbor_bottom = last_list_item.get_path()
	last_list_item.focus_neighbor_bottom = _player_confirm_button.get_path()


func _on_action_list_item_pressed(action : TB_Action) -> void:
	_player_battler.plan_action(action)
