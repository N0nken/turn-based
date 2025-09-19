class_name TB_IceAttack
extends TB_BasicAttack

func action() -> void:
	super()
	
	if target.status_effects.burn > 0:
		target.damage(ceil(target.max_health * Constants.BURN_FROZEN_EXPLOSION_DAMAGE * target.status_effects.burn))
		target.status_effects.frozen = 0
		target.status_effects.burn = 0
		target.status_effect_ended.emit(TB_Battler.StatusEffects.FROZEN)
		target.status_effect_ended.emit(TB_Battler.StatusEffects.BURN)
	else:
		target.apply_status_effect(TB_Battler.StatusEffects.FROZEN)
