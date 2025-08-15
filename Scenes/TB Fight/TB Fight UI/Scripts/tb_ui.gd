class_name TB_UI
extends CanvasLayer

enum ExitStates {
	PLAYER_WON,
	PLAYER_FLED,
	PLAYER_LOST
}

var packed_move_list_item := preload("res://Scenes/TB Fight/TB Fight UI/tb_fight_move_list_item.tscn")
var packed_action_icon := preload("res://Scenes/TB Fight/TB Fight UI/tb_fight_move_icon.tscn")

@onready var player : TB_Player = get_tree().root.get_node("TBFight/Battlers/TBPlayer")
var enemy : TB_AiBattler = null 

func _ready() -> void:
	for node in get_tree().root.get_node("TBFight/Battlers").get_children():
		if node is TB_AiBattler:
			enemy = node
			break;
	load_player_move_set()
	var tb_battler_hp_1 = get_node("Control/BattleViewport/TBBattlerHP")
	var tb_battler_hp_2 = get_node("Control/BattleViewport/TBBattlerHP2")
	tb_battler_hp_1.target_battler = player
	tb_battler_hp_2.target_battler = enemy
	tb_battler_hp_1.init_self()
	tb_battler_hp_2.init_self()
	player.action_started.connect(_on_action_started)
	enemy.action_started.connect(_on_action_started)


func load_player_move_set() -> void:
	for move in player.move_set:
		var new_move_list_item = packed_move_list_item.instantiate()
		new_move_list_item.action = move
		new_move_list_item.pressed.connect(_on_action_selected)
		get_node("Control/PlayerOptions/Tabs/Moves/ScrollContainer/VBoxContainer").add_child(new_move_list_item)


func load_player_backpack() -> void:
	pass


func _on_action_selected(action : TB_Action) -> void:
	if !player.plan_action(action):
		return
	var new_planned_action = packed_action_icon.instantiate()
	new_planned_action.set_icon(action.icon)
	get_node("Control/PlannedMoves/Player/MarginContainer/ScrollContainer/HBoxContainer").add_child(new_planned_action)


func _on_action_started(_action : TB_Action, battler : TB_Battler):
	print(_action.action_name, " was used by ", battler)
	var parent_container : HBoxContainer = null
	if battler == player:
		parent_container = get_node("Control/PlannedMoves/Player/MarginContainer/ScrollContainer/HBoxContainer")
	else:
		parent_container = get_node("Control/PlannedMoves/Enemy/MarginContainer/ScrollContainer/HBoxContainer")
	if parent_container.get_children().size() > 1:
		parent_container.get_child(1).queue_free()


func _on_fight_ended(exit_state : int) -> void:
	get_node("BattleEnded").visible = true
	if exit_state == ExitStates.PLAYER_WON:
		get_node("BattleEnded/CenterContainer/Panel/BattleResult").text = "Battle Won!"
		get_node("BattleEnded/CenterContainer/Panel/XPGain").text = "xp:100"
	elif exit_state == ExitStates.PLAYER_LOST:
		get_node("BattleEnded/CenterContainer/Panel/BattleResult").text = "Battle Lost!"
		get_node("BattleEnded/CenterContainer/Panel/XPGain").text = "xp:0"
	elif exit_state == ExitStates.PLAYER_FLED:
		get_node("BattleEnded/CenterContainer/Panel/BattleResult").text = "Battle Fled!"
		get_node("BattleEnded/CenterContainer/Panel/XPGain").text = "xp:0"
