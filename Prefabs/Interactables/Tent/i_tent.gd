class_name I_Tent
extends Interactable

@export var ui : MapUI = null


func _on_interacted() -> void:
	if not ui:
		return
	ui.show()
