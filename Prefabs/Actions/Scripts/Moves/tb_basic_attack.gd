class_name TB_BasicAttack
extends TB_Move

func action() -> void:
	target.damage(damage_formula.sample([self.power, parent_battler.strength, target.defense, 0, 0]))
