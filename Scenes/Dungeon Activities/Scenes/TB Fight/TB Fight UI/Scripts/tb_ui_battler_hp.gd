class_name TBUI_BattlerHp
extends Control

var target_battler : TB_Battler = null

func init_self() -> void:
	get_node("BattlerName").text = target_battler.battler_name
	get_node("ProgressBar").max_value = target_battler.max_health
	get_node("ProgressBar").value = target_battler.health
	target_battler.damaged.connect(_on_battler_damaged)

func _on_battler_damaged(_dmg : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("ProgressBar"), "value", target_battler.health, 0.2)
	#get_node("ProgressBar").value = target_battler.health
