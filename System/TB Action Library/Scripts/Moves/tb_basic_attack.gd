class_name TB_BasicAttack
extends TB_Move

func action() -> void:
	super()
	target.damage(power)
