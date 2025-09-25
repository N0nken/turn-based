extends Control

@export var _player_battler : TB_PlayerBattler
@export var _enemy_battler : TB_AiBattler

var planned_action_list_item : PackedScene = preload(Filepaths.TB_FIGHT_UI_NODES.move_icon)


func _ready() -> void:
	_player_battler.planned_action.connect(enqueue_action.bind(true))
	_enemy_battler.planned_action.connect(enqueue_action.bind(false))


func enqueue_action(action : TB_Action, is_player : bool) -> void:
	var container : HBoxContainer = _get_container(is_player)
	var icon : ActionIcon = planned_action_list_item.instantiate()
	container.add_child(icon)
	icon.set_icon(action.icon)


func dequeue_action(is_player : bool) -> void:
	var container : HBoxContainer = _get_container(is_player)
	container.remove_child(container.get_child(0))


func _get_container(is_player : bool) -> HBoxContainer:
	if is_player:
		return get_node("Player/MarginContainer/ScrollContainer/HBoxContainer")
	else:
		return get_node("Enemy/MarginContainer/ScrollContainer/HBoxContainer")
