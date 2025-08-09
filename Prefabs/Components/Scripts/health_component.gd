class_name HealthComponent
extends Node

signal damaged(damage : int)
signal healed(heal : int)
signal died

@export var max_health := 0

@onready var health := max_health


func damage(dmg : int) -> void:
	health -= dmg
	health = clamp(health, 0, max_health)
	
	if dmg > 0:
		damaged.emit(dmg)
	elif dmg < 0:
		healed.emit(dmg)
	if health == 0:
		died.emit()
