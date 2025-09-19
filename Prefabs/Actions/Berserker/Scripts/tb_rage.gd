class_name TB_Rage
extends TB_Move

func action() -> void:
	parent_battler.apply_status_effect(TB_Battler.StatusEffects.RAGE)
