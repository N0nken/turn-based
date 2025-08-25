class_name CloudSpawner
extends Node2D

@export var clouds : Array[Texture2D] = []
## Time between each cloud spawn
@export var cloud_spawn_frequency := 1.0
## Chance for cloud to die after certain time
@export var cloud_lifetime_chance := 0.0
## Lifetime in seconds
@export var max_cloud_lifetime := 0.0
@export var min_cloud_lifetime := 0.0
## Distance per second
@export var relative_cloud_speed := false
@export var max_cloud_speed := 0.0
@export var min_cloud_speed := 0.0

var packed_cloud := preload(Filepaths.PACKED_CLOUD)

func _ready() -> void:
	get_node("CloudSpawnCooldown").wait_time = cloud_spawn_frequency
	get_node("CloudSpawnCooldown").start()
	spawn_cloud()

func _on_cloud_spawn_cooldown_timeout() -> void:
	spawn_cloud()


func spawn_cloud() -> void:
	var new_cloud = packed_cloud.instantiate()
	new_cloud.get_node("Sprite2D").texture = clouds.pick_random()
	var paths := get_node("Paths").get_children()
	var selected_path_index := randi_range(0, paths.size() - 1)
	if not relative_cloud_speed:
		new_cloud.speed = randf_range(min_cloud_speed, max_cloud_speed)
	else:
		new_cloud.speed = (min_cloud_speed + max_cloud_speed) / 2 / selected_path_index
	if randf() < cloud_lifetime_chance:
		new_cloud.lifetime = randf_range(min_cloud_lifetime, max_cloud_lifetime);
	paths[selected_path_index].add_child(new_cloud)
