class_name TB_PotionOfHealing
extends TB_Item

func action(efficiency : float) -> void:
	parent.damage(Damage.new(Damage.DamageTypes.HEALING, -parent.armor.health * Constants.POTION_OF_HEALING_RATIO * efficiency))
