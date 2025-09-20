class_name Weapon
extends Equipment

@export var move_1 : TB_Move
@export var move_2 : TB_Move
@export var move_3 : TB_Move
@export var move_4 : TB_Move

@export_range(1, 10) var strength := 1 :
	get:
		return strength * level
@export_range(1, 10) var speed := 1 :
	get:
		return speed * level
@export_range(1, 100) var turn_plan_capacity := 1 :
	get:
		return turn_plan_capacity * level


var move_set : Array[TB_Move] = [move_1, move_2, move_3, move_4]
var damage_buffs := 0


func move_damage(move : TB_Move) -> Damage:
	return Damage.new(move.damage_type, self.strength * move.power * (damage_buffs + 1))


func move_speed(move : TB_Move) -> int:
	return self.speed * move.speed
