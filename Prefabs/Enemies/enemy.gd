class_name Enemy
extends Resource

@export var name : String
@export var sprite : Texture2D
@export var icon : Texture2D
@export var base_stats : Dictionary[String, int] = {
	"health" : 0,
	"strength" : 0,
	"speed" : 0,
	"defense" : 0,
	"turn_plan_capacity" : 0,
}
@export var statbias : Dictionary[String, float] = {
	"health" : 0,
	"strength" : 0,
	"speed" : 0,
	"defense" : 0,
	"turn_plan_capacity" : 0,
}
@export var move_set : Array[TB_Action] = []
