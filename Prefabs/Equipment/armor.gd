class_name Armor
extends Equipment

@export_range(1, 100) var health := 1 :
	get:
		return health * level
@export_range(1, 10) var defense := 1 :
	get:
		return defense * level

var defense_buffs := 0.0


func damage(damage_instance : Damage, efficiency : float = 1.0) -> int:
	var new_defense_buffs := _get_defense_buffs(damage_instance)
	defense_buffs += new_defense_buffs
	var dmg : float = float(damage_instance.damage) / float((defense * (defense_buffs + 1) + 1))
	defense_buffs -= new_defense_buffs
	return int(ceil(dmg * efficiency))


func _get_stringified_stats() -> String:
	var result : String = super() + "\n"
	result += "HP : " + str(health) + "\n"
	result += "Def: " + str(defense)
	return result


func _get_defense_buffs(_damage_instance : Damage) -> float:
	return 0.0
