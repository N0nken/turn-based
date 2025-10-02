class_name TB_BattlerSprite
extends Node2D

@export var tracked_battler : TB_Battler

@onready var sprite : Sprite2D = get_node("Sprite2D")
@onready var hurt_effect_timer : Timer = get_node("HurtEffectTimer")


func _ready() -> void:
	tracked_battler.damaged.connect(_on_battler_damaged)


func setup() -> void:
	if tracked_battler.sprite != null:
		sprite.texture = tracked_battler.sprite


func _on_battler_damaged() -> void:
	self.material.set_shader_parameter("enabled", true)
	hurt_effect_timer.start()


func _on_hurt_effect_timer_timeout() -> void:
	self.material.set_shader_parameter("enabled", false)
