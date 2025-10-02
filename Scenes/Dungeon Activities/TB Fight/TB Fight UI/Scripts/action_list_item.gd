class_name TB_ActionListItem
extends Button

var action : TB_Action = null

func _ready() -> void:
	if action.icon:
		icon = action.icon
	else:
		icon = load(Filepaths.TEXTURE_NOT_FOUND)
	text = action.action_name
