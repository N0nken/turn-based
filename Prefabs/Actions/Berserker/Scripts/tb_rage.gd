class_name TB_Rage
extends TB_Move

func action() -> void:
	parent.apply_status_effect(TB_Battler.StatusEffects.RAGE)
