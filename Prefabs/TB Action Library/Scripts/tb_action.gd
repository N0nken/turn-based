class_name TB_Action
extends Resource

@export var action_name := ""
@export var power := 0 # damage/buff% (negative to heal/debuff)
@export var target_self := false
@export var icon : Texture2D = null 
@export var life_time := 0.5

var tb_fight_root : TB_Fight = null
var target : TB_Battler = null
var parent_battler : TB_Battler = null

func action() -> void:
	pass
