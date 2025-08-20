class_name TB_AudioStreamPlayer
extends AudioStreamPlayer

func _on_battler_hurt(battler : TB_Battler) -> void:
	if battler.health > 0:
		stream = battler.hurt_sound_effect
	play()


func _on_battler_died(battler : TB_Battler) -> void:
	stream = battler.death_sound_effect
	play()
