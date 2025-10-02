class_name Weapon
extends Equipment

@export_range(1, 10) var strength := 1 :
	get:
		return strength * level
@export_range(1, 10) var speed := 1 :
	get:
		return speed * level
@export_range(1, 100) var turn_plan_capacity := 1 :
	get:
		return turn_plan_capacity * level
@export var move_set : Array[TB_Move]


var damage_buffs := 0


func move_damage(move : TB_Move, efficiency : float = 1.0) -> Damage:
	var move_specific_buffs : int = move.get_buffs()
	var total_buffs := move_specific_buffs + damage_buffs + _weapon_specific_damage_buffs(move)
	return Damage.new(move.damage_type, self.strength * move.power * (total_buffs + 1) * efficiency)


func move_speed(move : TB_Move) -> int:
	return self.speed * move.speed


func _weapon_specific_damage_buffs(_move : TB_Move) -> int:
	return 0


func _get_stringified_stats() -> String:
	var result : String = super() + "\n"
	result += "Str: " + str(strength) + "\n"
	result += "Spd: " + str(speed) + "\n"
	result += "Cap: " + str(turn_plan_capacity) + "\n\n"
	
	result += "move set: "
	for i in move_set.size():
		var move : TB_Move = move_set[i]
		result += "\n[" + str(i+1) + "] [color=%s]" % Damage.get_damage_color_hex(move.damage_type) + move.action_name + "[/color]"
	return result
