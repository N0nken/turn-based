class_name InteractableArea
extends Area2D

signal player_entered
signal player_exited

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerEntity:
		player_entered.emit()


func _on_body_exited(body: Node2D) -> void:
	if body is PlayerEntity:
		player_exited.emit()
