class_name MapDungeon
extends Button

signal selected

enum States {
	LOCKED,
	OPEN,
	CLEARED,
}

var state := States.LOCKED
var template_name := ""

func _ready() -> void:
	if state == States.LOCKED:
		get_node("Locked").show()
		get_node("Cleared").hide()
	elif state == States.OPEN:
		get_node("Locked").hide()
		get_node("Cleared").hide()
	elif state == States.CLEARED:
		get_node("Locked").hide()
		get_node("Cleared").show()


func unlock() -> void:
	state = States.OPEN
	get_node("Locked").hide()


func clear() -> void:
	state = States.CLEARED
	get_node("Cleared").show()


func _on_focus_entered() -> void:
	self.material.set_shader_parameter("enabled", true)


func _on_focus_exited() -> void:
	self.material.set_shader_parameter("enabled", false)


func _on_pressed() -> void:
	if state != States.OPEN:
		return
	selected.emit()
