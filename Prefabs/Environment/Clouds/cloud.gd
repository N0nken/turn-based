class_name Cloud
extends PathFollow2D

var lifetime := 0.0
var speed := 0.0

func _ready() -> void:
	if lifetime > 0:
		get_node("Lifetime").start(lifetime)


func _physics_process(delta: float) -> void:
	if self.progress_ratio >= 1:
		self.queue_free()
	self.progress += speed * delta


func _on_lifetime_timeout() -> void:
	self.queue_free()
