class_name TB_BasicAttack
extends TB_Move


func action() -> void:
	var damage := calculate_damage()
	target.damage(damage)


func get_buffs() -> int:
	var buffs := 0
	if parent_battler.status_effects.rage > 0:
		if parent_battler.health < parent_battler.max_health * Constants.RAGE_DAMAGE_INCREASE_LIMIT:
			buffs += Constants.RAGE_DAMAGE_INCREASE
	return buffs


func get_debuffs() -> int:
	var debuffs := 0
	if target.status_effects.rage > 0:
		if parent_battler.health < parent_battler.max_health * Constants.RAGE_DAMAGE_DECREASE_LIMIT:
			debuffs += Constants.RAGE_DAMAGE_DECREASE_LIMIT
	return debuffs


func calculate_damage() -> int:
	return ceil(damage_formula.sample([self.power, parent_battler.strength, target.defense, get_buffs(), get_debuffs()]))
