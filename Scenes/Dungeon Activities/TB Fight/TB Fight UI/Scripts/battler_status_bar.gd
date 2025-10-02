class_name TB_BattlerStatusBar
extends Control

@export var left_aligned_status_effects := true
@export var elevated_status_effects := false
@export var tracked_battler : TB_Battler = null

var status_effect_icon := preload(Filepaths.STATUS_EFFECT_ICON)


func _ready() -> void:
	if not left_aligned_status_effects:
		get_node("StatusEffects/HBoxContainer").alignment = BoxContainer.ALIGNMENT_END
	if elevated_status_effects:
		get_node("StatusEffects/HBoxContainer").global_position.y = self.global_position.y - 9


func setup() -> void:
	get_node("BattlerName").text = tracked_battler.battler_name
	get_node("ProgressBar").max_value = tracked_battler.armor.health
	get_node("ProgressBar").value = tracked_battler.get_health()
	tracked_battler.damaged.connect(_on_battler_damaged)
	tracked_battler.applied_status_effect.connect(_on_battler_status_effect_applied)
	tracked_battler.cleared_status_effect.connect(_on_battler_status_effect_cleared)


func _on_battler_damaged() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(get_node("ProgressBar"), "value", tracked_battler.get_health(), 0.2)


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


func _on_battler_status_effect_cleared(status_effect : TB_Battler.StatusEffects) -> void:
	var target_region_x := get_region_x_from_status(status_effect)
	for sf_icon in get_node("StatusEffects/HBoxContainer").get_children():
		if sf_icon.texture.region.position.x == target_region_x:
			sf_icon.queue_free()


static func get_region_x_from_status(status_effect : TB_Battler.StatusEffects) -> int:
	match status_effect:
		TB_Battler.StatusEffects.BURN:
			return 0
		TB_Battler.StatusEffects.FROZEN:
			return 8
		TB_Battler.StatusEffects.ELECTRIFIED:
			return 16
		TB_Battler.StatusEffects.RAGE:
			return 24
		_:
			return -1
