extends CanvasLayer

func setup() -> void:
	get_node("Control/PlayerOptions/Tabs").setup()
	get_node("Control/BattleViewport/Battle/EnemyStatusBar").setup()
	get_node("Control/BattleViewport/Battle/PlayerStatusBar").setup()
	var action_list_container : VActionContainer = get_node("Control/PlayerOptions/Tabs/Moves/ScrollContainer/VActionContainer")
	for action_list_item in action_list_container.get_children():
		action_list_item.focus_entered.connect(get_node("Control/InfoBox").update_action.bind(action_list_item.action))
	get_node("Control/InfoBox").update_action(action_list_container.get_child(0).action)
