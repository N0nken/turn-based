class_name Armor
extends Equipment

@export_range(1, 100) var health := 1 :
	get:
		return health * level
@export_range(1, 10) var defense := 1 :
	get:
		return defense * level

var defense_buffs := 0


func damage(damage_instance : Damage) -> int:
	var dmg : int = ceil(float(damage_instance.damage) / float((defense * (defense_buffs + 1) + 1)))
	return dmg


func _get_stringified_stats() -> String:
	var result : String = super() + "\n"
	result += "HP : " + str(health) + "\n"
	result += "Def: " + str(defense)
	return result
