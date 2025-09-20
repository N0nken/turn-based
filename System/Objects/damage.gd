class_name Damage
extends RefCounted

enum DamageTypes {
	PHYSICAL,
	FIRE,
	ICE,
	ELECTRIC,
}
var type := DamageTypes.PHYSICAL
var damage := 0

func _init(type : DamageTypes, damage : int) -> void:
	self.type = type
	self.damage = damage
