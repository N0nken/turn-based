class_name TB_BasicAttack
extends TB_Move


func action(efficiency : float) -> void:
	var damage : Damage = parent.weapon.move_damage(self)
	damage.damage *= efficiency
	target.damage(damage)
