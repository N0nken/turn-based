class_name TB_InfoBox
extends InfoBox

@export var visibility_transition_time := 0.1

func _ready() -> void:
	self.modulate.a = 0


func update_action(action : TB_Action) -> void:
	update_info(action.icon, action.action_name, action.description)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_info_box"):
		if self.modulate.a == 0:
			var new_tween : Tween = get_tree().create_tween()
			new_tween.tween_property(self, "modulate", Color(1,1,1,1), visibility_transition_time)
			new_tween.tween_property(self, "scale", Vector2(1,1), visibility_transition_time)
		elif self.modulate.a == 1:
			var new_tween : Tween = get_tree().create_tween()
			new_tween.tween_property(self, "scale", Vector2(0,0), visibility_transition_time)
			new_tween.tween_property(self, "modulate", Color(1,1,1,0), visibility_transition_time)
		get_viewport().set_input_as_handled()
