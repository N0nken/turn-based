class_name TB_IceAttack
extends TB_BasicAttack

func action() -> void:
	super()
	
	if target.is_afflicted_by(TB_Battler.StatusEffects.BURN):
		var explosion_damage := Damage.new(Damage.DamageTypes.ICE, target.armor.health * Constants.BURN_FROZEN_EXPLOSION_DAMAGE)
		target.damage(explosion_damage)
		target.clear_status_effect(TB_Battler.StatusEffects.BURN)
		target.clear_status_effect(TB_Battler.StatusEffects.FROZEN)
	else:
		target.apply_status_effect(TB_Battler.StatusEffects.FROZEN)
