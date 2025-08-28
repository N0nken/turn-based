class_name MapUI
extends Control

@export var shader_map : ColorRect = null
@export var shader_map_gradients : Array[Gradient] = []
@export var randomize_color_curve := false
@export var selected_color_curve := -1
@export var dungeon_icons : Array[Texture2D] = []
@export var dungeon_count := 3
@export var dungeon_position_x_offset := Vector2i(5, 5)
@export var dungeon_position_graph : Graph = null

var graph_offset = randi_range(0, 50)
var packed_dungeon := preload(Filepaths.MAP_DUNGEON)


func _ready() -> void:
	if LoadedRun.map_generated:
		_load_map()
	else:
		_generate_map()
	self.visibility_changed.connect(_on_visibility_changed)
	get_node("Map/Dungeons").get_child(0).grab_focus()


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("menu_back"):
			self.hide()


func _generate_map() -> void:
	if shader_map:
		var height_map : NoiseTexture2D = shader_map.material.get_shader_parameter("height_map")
		height_map.noise.seed = randi()
		var gradient_idx := randi_range(0, shader_map_gradients.size()-1)
		height_map.color_ramp = shader_map_gradients[gradient_idx]
		shader_map.material.set_shader_parameter("height_map", height_map)
		LoadedRun.map_noise_seed = height_map.noise.seed
		@warning_ignore("int_as_enum_without_cast")
		LoadedRun.map_biome = gradient_idx
	_generate_dungeons(dungeon_count)
	_generate_lines()
	get_node("Map/Dungeons").get_child(0).unlock()
	LoadedRun.map_generated = true


func _generate_dungeons(count : int) -> void:
	var dungeon_parent : Control = get_node("Map/Dungeons")
	for i in range(count):
		var new_dungeon := packed_dungeon.instantiate()
		new_dungeon.icon = dungeon_icons.pick_random()
		var c := dungeon_parent.size.x / count * (i + 1)
		new_dungeon.position.x = randi_range(c - dungeon_position_x_offset.x, c + dungeon_position_x_offset.y) - 100 / (2 * count) - new_dungeon.size.x / 2
		new_dungeon.position.y = _get_dungeon_y(new_dungeon.position.x)
		new_dungeon.position -= dungeon_parent.size / 2.0
		dungeon_parent.add_child(new_dungeon)
		var new_loaded_dungeon := LoadedRun.Dungeon.new()
		new_loaded_dungeon.position = new_dungeon.position
		print(new_dungeon.position, new_loaded_dungeon.position)
		LoadedRun.map_dungeons.append(new_loaded_dungeon)
	
	for i in range(dungeon_parent.get_child_count() - 1):
		var dungeon : MapDungeon = dungeon_parent.get_child(i)
		var next_dungeon : MapDungeon = dungeon_parent.get_child(i+1)
		dungeon.focus_neighbor_right = next_dungeon.get_path()
		next_dungeon.focus_neighbor_left = dungeon.get_path()


func _get_dungeon_y(x : int) -> int:
	return int(dungeon_position_graph.sample([x, graph_offset]))


func _load_map() -> void:
	if shader_map:
		var height_map : NoiseTexture2D = shader_map.material.get_shader_parameter("height_map")
		height_map.noise.seed = LoadedRun.map_noise_seed
		height_map.color_ramp = shader_map_gradients[LoadedRun.map_biome]
		shader_map.material.set_shader_parameter("height_map", height_map)
	_load_dungeons(LoadedRun.map_dungeons.size())
	_generate_lines()


func _load_dungeons(count : int) -> void:
	var dungeon_parent : Control = get_node("Map/Dungeons")
	for i in range(count):
		var loaded_dungeon := LoadedRun.map_dungeons[i]
		var new_dungeon : MapDungeon = packed_dungeon.instantiate()
		new_dungeon.position = loaded_dungeon.position
		new_dungeon.state = loaded_dungeon.state
		dungeon_parent.add_child(new_dungeon)


func _generate_lines() -> void:
	var line : Line2D = get_node("Map/Line2D")
	for dungeon in get_node("Map/Dungeons").get_children():
		line.add_point(dungeon.global_position + Vector2(8,16))
		line.global_position = Vector2(0,0)


func _on_button_pressed() -> void:
	self.hide()


func _on_visibility_changed() -> void:
	if visible:
		get_node("ExitButton").grab_focus()
