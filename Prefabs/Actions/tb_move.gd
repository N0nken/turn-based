class_name TB_Move
extends TB_Action

@export var cost := Costs.LOW # turn plan capacity cost
@export var speed := Speeds.LOW # determines turn order
@export var damage_type := Damage.DamageTypes.PHYSICAL

func get_buffs() -> int:
	var buffs := 0
	
	return buffs


func get_debuffs() -> int:
	var debuffs := 0
	
	return debuffs
