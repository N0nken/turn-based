class_name TB_ElectricAttack
extends TB_BasicAttack

func action() -> void:
	super()
	
	target.apply_status_effect(TB_Battler.StatusEffects.ELECTRIFIED)


func get_buffs() -> int:
	var buffs := super()
	
	if target.is_afflicted_by(TB_Battler.StatusEffects.FROZEN):
		buffs += Constants.FROZEN_ELECTRICITY_BUFF
	
	return buffs


func get_debuffs() -> int:
	var debuffs := super()
	
	if target.is_afflicted_by(TB_Battler.StatusEffects.BURN):
		debuffs += Constants.BURN_ELECTRICITY_DEBUFF
	
	return debuffs
