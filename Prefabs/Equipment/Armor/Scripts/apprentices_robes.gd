class_name ApprenticesRobes
extends Armor


func _get_defense_buffs(damage_instance : Damage) -> float:
	var buffs := 0.0
	if damage_instance.type in Damage.ELEMENTAL_DAMAGE_TYPES:
		buffs += 0.1
	return buffs
