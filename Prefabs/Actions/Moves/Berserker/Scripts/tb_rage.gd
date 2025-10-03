class_name TB_Rage
extends TB_Move

func action(_efficiency : float) -> void:
	parent.apply_status_effect(TB_Battler.StatusEffects.RAGE)
