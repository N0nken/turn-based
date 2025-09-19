class_name TBUI_BattlerHp
extends Control

@export var left_aligned_status_effects := true
@export var elevated_status_effects := false

var target_battler : TB_Battler = null
var status_effect_icon := preload(Filepaths.STATUS_EFFECT_ICON)


func init_self() -> void:
	get_node("BattlerName").text = target_battler.battler_name
	get_node("ProgressBar").max_value = target_battler.max_health
	get_node("ProgressBar").value = target_battler.health
	target_battler.damaged.connect(_on_battler_damaged)
	target_battler.status_effect_applied.connect(_on_battler_status_effect_applied)
	target_battler.status_effect_ended.connect(_on_battler_status_effect_ended)


func _ready() -> void:
	if not left_aligned_status_effects:
		get_node("StatusEffects/HBoxContainer").alignment = BoxContainer.ALIGNMENT_END
	if elevated_status_effects:
		get_node("StatusEffects/HBoxContainer").global_position.y = self.global_position.y - 9



func _on_battler_damaged(_dmg : int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("ProgressBar"), "value", target_battler.health, 0.2)
	#get_node("ProgressBar").value = target_battler.health


func _on_battler_status_effect_applied(status_effect : TB_Battler.StatusEffects) -> void:
	match status_effect:
		TB_Battler.StatusEffects.BURN:
			var new_status_effect_icon := status_effect_icon.instantiate()
			new_status_effect_icon.texture.region.position.x = 0
			get_node("StatusEffects/HBoxContainer").add_child(new_status_effect_icon)
		TB_Battler.StatusEffects.FROZEN:
			var new_status_effect_icon := status_effect_icon.instantiate()
			new_status_effect_icon.texture.region.position.x = 8
			get_node("StatusEffects/HBoxContainer").add_child(new_status_effect_icon)
		TB_Battler.StatusEffects.ELECTRIFIED:
			var new_status_effect_icon := status_effect_icon.instantiate()
			new_status_effect_icon.texture.region.position.x = 16
			get_node("StatusEffects/HBoxContainer").add_child(new_status_effect_icon)
		TB_Battler.StatusEffects.RAGE:
			var new_status_effect_icon := status_effect_icon.instantiate()
			new_status_effect_icon.texture.region.position.x = 24
			get_node("StatusEffects/HBoxContainer").add_child(new_status_effect_icon)


func _on_battler_status_effect_ended(status_effect : TB_Battler.StatusEffects) -> void:
	match status_effect:
		TB_Battler.StatusEffects.BURN:
			for sf_icon in get_node("StatusEffects/HBoxContainer").get_children():
				if sf_icon.texture.region.position.x == 0:
					sf_icon.queue_free()
					break
		TB_Battler.StatusEffects.FROZEN:
			for sf_icon in get_node("StatusEffects/HBoxContainer").get_children():
				if sf_icon.texture.region.position.x == 8:
					sf_icon.queue_free()
					break
		TB_Battler.StatusEffects.ELECTRIFIED:
			for sf_icon in get_node("StatusEffects/HBoxContainer").get_children():
				if sf_icon.texture.region.position.x == 16:
					sf_icon.queue_free()
					break
		TB_Battler.StatusEffects.RAGE:
			for sf_icon in get_node("StatusEffects/HBoxContainer").get_children():
				if sf_icon.texture.region.position.x == 24:
					sf_icon.queue_free()
					break
