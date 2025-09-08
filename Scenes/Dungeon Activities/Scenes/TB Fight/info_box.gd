extends Control

@export var header_template := ""
@export var visibility_transition_time := 0.1


func update_header(icon_uid : String, item_name : String) -> void:
	var formatted_header := header_template % [icon_uid, item_name]
	get_node("Header").text = formatted_header


func update_description(new_description : String) -> void:
	get_node("Description").text = new_description


func update_info(icon_uid : String, item_name : String, new_description : String) -> void:
	update_header(icon_uid, item_name)
	update_description(new_description)


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
