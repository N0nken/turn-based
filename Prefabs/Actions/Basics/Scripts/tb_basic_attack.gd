class_name TB_BasicAttack
extends TB_Move


func action() -> void:
	target.damage(parent_battler.weapon.move_damage(self))
