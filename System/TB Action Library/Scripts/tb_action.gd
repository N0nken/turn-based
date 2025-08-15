class_name TB_Action
extends Resource

signal action_used(action : TB_Action)

@export var action_name := ""
@export var power := 0 # damage/buff% (negative to heal/debuff)
@export var target_self := false
@export var icon : Texture2D = null 

var tb_fight_root : TB_Fight = null
var target : TB_Battler = null
var parent_battler : TB_Battler = null

func action() -> void:
	action_used.emit(self)
