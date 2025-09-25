class_name TB_Action
extends Resource

enum Powers {
	ZERO,
	LOW,
	LOW_MED,
	MEDIUM,
	MED_HIGH,
	HIGH,
}

enum Costs {
	ZERO,
	LOW,
	LOW_MED,
	MEDIUM,
	MED_HIGH,
	HIGH,
}

enum Speeds {
	ZERO,
	LOW,
	LOW_MED,
	MEDIUM,
	MED_HIGH,
	HIGH,
}

@export var action_name := ""
@export var icon : Texture2D = null
@export var power := Powers.LOW
@export var target_self := false
@export var life_time := 0.5
@export_multiline var description := ""

var target : TB_Battler = null
var parent : TB_Battler = null


func _init() -> void:
	if icon == null:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)


func action() -> void:
	pass
