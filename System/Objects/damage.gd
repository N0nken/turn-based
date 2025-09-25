class_name Damage
extends RefCounted

enum DamageTypes {
	PHYSICAL,
	FIRE,
	ICE,
	ELECTRIC,
}

static var _damage_colors : Dictionary[DamageTypes, String] = {
	DamageTypes.PHYSICAL : "#cccccc",
	DamageTypes.FIRE : "#eb5234",
	DamageTypes.ICE : "#7df0ff",
	DamageTypes.ELECTRIC : "#ffff00",
}

var type := DamageTypes.PHYSICAL
var damage := 0


func _init(damage_type : DamageTypes, damage_value : int) -> void:
	self.type = damage_type
	self.damage = damage_value


static func get_damage_color_hex(damage_type : DamageTypes) -> String:
	return _damage_colors[damage_type]
