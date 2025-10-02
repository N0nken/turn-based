class_name TB_BasicAttack
extends TB_Move


func action(efficiency : float) -> void:
	target.damage(parent.weapon.move_damage(self))
