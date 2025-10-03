extends CanvasLayer

@onready var minigame_background_tint : ColorRect = get_node("Control/MinigameBackgroundTint")
@onready var minigame : TB_Minigame = get_node("Control/BattleViewport/Minigame")

func setup() -> void:
	get_node("Control/PlayerOptions/Tabs").setup()
	get_node("Control/BattleViewport/Battle/EnemyStatusBar").setup()
	get_node("Control/BattleViewport/Battle/PlayerStatusBar").setup()
	var action_list_container : VActionContainer = get_node("Control/PlayerOptions/Tabs/Moves/ScrollContainer/VActionContainer")
	for action_list_item in action_list_container.get_children():
		action_list_item.focus_entered.connect(get_node("Control/InfoBox").update_action.bind(action_list_item.action))
	get_node("Control/InfoBox").update_action(action_list_container.get_child(0).action)


func _on_minigame_visibility_changed() -> void:
	minigame_background_tint.visible = minigame.visible
