class_name TB_Action
extends Node

signal action_ended

@export var power := 0 # damage/buff% (negative to heal/debuff)
@export var cost := 0 # turn plan capacity cost
@export var speed := 0 # determines turn order
@export var target_self := false

var target : TB_Battler = null
var parent_battler : TB_Battler = null

func _ready() -> void:
	parent_battler = get_parent().get_parent()


func action() -> void:
	action_ended.emit()
