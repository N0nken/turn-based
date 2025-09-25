extends Node

enum States {
	INACTIVE,
	LOADING_SCENE,
}

var scene_tree := {
	"main_menu" : ["map"],
	"map" : ["dungeon"],
	"dungeon" : ["map", "game_over"],
	"game_over" : ["main_menu"]
}

var current_scene := "main_menu"
var state := States.INACTIVE
var target_scene_name := ""
var target_scene : PackedScene = null
var scene_loading_thread := Thread.new()
var scene_finished_loading_check_frequency := 0.1
var scene_finished_loading_check_timer := 0.0
var scene_loaded_mutex := Mutex.new()
var loading_screen_scene : PackedScene = preload(Filepaths.SCENES["loading_screen"])


func _physics_process(delta: float) -> void:
	if state == States.LOADING_SCENE:
		scene_finished_loading_check_timer += delta
		if scene_finished_loading_check_timer >= scene_finished_loading_check_frequency:
			scene_finished_loading_check_timer = 0
			scene_loaded_mutex.lock()
			if target_scene:
				state = States.INACTIVE
				get_tree().change_scene_to_packed(target_scene)
				current_scene = target_scene_name
				target_scene_name = ""
			scene_loaded_mutex.unlock()


## Set [param outcome] to target outcome scene for scenes with multiple outcomes
func next_scene(outcome : int = 0) -> void:
	if scene_loading_thread.is_started():
		scene_loading_thread.wait_to_finish()
	target_scene_name = scene_tree[current_scene][outcome]
	scene_loading_thread.start(load_scene.bind(target_scene_name))
	get_tree().change_scene_to_packed(loading_screen_scene)


func load_scene(scene : String) -> void:
	state = States.LOADING_SCENE
	var loaded_scene : PackedScene = load(Filepaths.SCENES[scene])
	scene_loaded_mutex.lock()
	target_scene = loaded_scene
	scene_loaded_mutex.unlock()
