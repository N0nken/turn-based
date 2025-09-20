class_name Armor
extends Equipment

signal damaged(damage : int)
signal healed(healing : int)
signal died

@export_range(1, 100) var health := 1 :
	get:
		return health * level
@export_range(1, 10) var defense := 1 :
	get:
		return defense * level

var current_health := health * level
var defense_buffs := 0

func damage(damage : Damage) -> void:
	var dmg = damage.damage / (defense * (defense_buffs + 1))
	current_health = clamp(current_health, 0, health)
	
	if dmg > 0:
		damaged.emit(dmg)
	elif dmg < 0:
		healed.emit(dmg)
	if health <= 0:
		died.emit()
