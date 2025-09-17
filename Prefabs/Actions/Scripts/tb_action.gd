class_name TB_Action
extends Resource

enum ComboTypes {
	PHYSICAL, 
	MAGIC,
}

@export var action_name := ""
@export var power := 0 # damage/buff% (negative to heal/debuff)
@export var target_self := false
@export var icon : Texture2D = null 
@export var life_time := 0.5
@export var description := ""
@export var icon_uid := ""
@export var combo_type := ComboTypes.PHYSICAL

var tb_fight_root : TB_Fight = null
var target : TB_Battler = null
var parent_battler : TB_Battler = null
var damage_formula : Formula = null

func _init() -> void:
	damage_formula = load(Filepaths.DAMAGE_FORMULA)

func action() -> void:
	pass
