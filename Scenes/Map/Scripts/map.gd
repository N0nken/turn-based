class_name Map
extends Control

enum Biomes {
	MOUNTAINOUS_FOREST,
	VOLCANIC_FOREST,
	FROZEN_LAKES,
	SNOWY_PEAKS,
	HELL,
}

@export var map_biome := Biomes.MOUNTAINOUS_FOREST
@export var map_presets : Array[MapPreset] = []
@export var dungeon_position_graph : Formula = null
@export var shader_map : ColorRect = null
@export var dungeon_count := 3
@export var dungeon_position_x_offset := Vector2i(5, 5)
@export var graph_period := 100
@export var graph_amplitude := 30
@export var graph_offset := 0
@export var graph_shift := Vector2.ZERO

var packed_dungeon : PackedScene = preload(Filepaths.MAP_DUNGEON)
var next_stage_dungeon_icon : Texture2D = preload(Filepaths.TEXTURE_NOT_FOUND)
var selected_map_preset : MapPreset = null

@onready var dungeon_parent = get_node("Map/Dungeons")


func _enter_tree() -> void:
	selected_map_preset = map_presets[LoadedRun.map_biome]


func _ready() -> void:
	if LoadedRun.map_generated:
		_load_map()
	else:
		_generate_map()
	dungeon_parent.get_child(0).grab_focus()


func _generate_map() -> void:
	map_biome = Biomes.values()[LoadedRun.stage % Biomes.values().size()]
	if shader_map:
		var color_map : NoiseTexture2D = shader_map.material.get_shader_parameter("color_map")
		var normal_map : NoiseTexture2D = shader_map.material.get_shader_parameter("normal_map")
		color_map.noise.seed = randi()
		color_map.color_ramp = map_presets[map_biome].color_gradient
		shader_map.material.set_shader_parameter("color_map", color_map)
		normal_map.noise.seed = color_map.noise.seed
		shader_map.material.set_shader_parameter("normal_map", normal_map)
		LoadedRun.map_noise_seed = color_map.noise.seed
		#@warning_ignore("int_as_enum_without_cast")
		LoadedRun.map_biome = map_biome
	_generate_dungeons(dungeon_count)
	_generate_lines()
	dungeon_parent.get_child(0).unlock()
	LoadedRun.map_generated = true


func _generate_dungeons(count : int) -> void:
	for i in range(count):
		var new_dungeon := packed_dungeon.instantiate()
		new_dungeon.icon = map_presets[map_biome].dungeon_icon
		var c : float = dungeon_parent.size.x / (count) * (i + 1)
		new_dungeon.position.x = randi_range(c - dungeon_position_x_offset.x, c + dungeon_position_x_offset.y) - shader_map.size.x / (2 * (count + 1)) - new_dungeon.size.x / 2
		new_dungeon.position.y = _get_dungeon_y(new_dungeon.position.x)
		new_dungeon.position -= dungeon_parent.size / 2.0
		dungeon_parent.add_child(new_dungeon)
		new_dungeon.selected.connect(_on_dungeon_selected.bind(i))
		var new_loaded_dungeon := LoadedRun.Dungeon.new()
		new_loaded_dungeon.position = new_dungeon.position
		#print(new_dungeon.position, new_loaded_dungeon.position)
		LoadedRun.map_dungeons.append(new_loaded_dungeon)
	
	for i in range(dungeon_parent.get_child_count() - 1):
		var dungeon : MapDungeon = dungeon_parent.get_child(i)
		var next_dungeon : MapDungeon = dungeon_parent.get_child(i+1)
		dungeon.focus_neighbor_right = next_dungeon.get_path()
		next_dungeon.focus_neighbor_left = dungeon.get_path()


func _get_dungeon_y(x : int) -> int:
	var A := graph_amplitude
	var P := graph_period
	var O := shader_map.size.y / 2 + graph_offset
	var S := randi_range(graph_shift.x, graph_shift.y)
	return int(dungeon_position_graph.sample([x, A, P, O, S]))


func _load_map() -> void:
	if shader_map:
		var color_map : NoiseTexture2D = shader_map.material.get_shader_parameter("color_map")
		color_map.noise.seed = LoadedRun.map_noise_seed
		color_map.color_ramp = map_presets[LoadedRun.map_biome].color_gradient
		shader_map.material.set_shader_parameter("color_map", color_map)
	_load_dungeons(LoadedRun.map_dungeons.size())
	_generate_lines()


func _load_dungeons(count : int) -> void:
	for i in range(count):
		var loaded_dungeon := LoadedRun.map_dungeons[i]
		var new_dungeon : MapDungeon = packed_dungeon.instantiate()
		new_dungeon.position = loaded_dungeon.position
		new_dungeon.state = loaded_dungeon.state
		dungeon_parent.add_child(new_dungeon)
		new_dungeon.selected.connect(_on_dungeon_selected.bind(i))


func _generate_lines() -> void:
	var line : Line2D = get_node("Map/Line2D")
	for dungeon in dungeon_parent.get_children():
		line.add_point(dungeon.global_position + Vector2(8,16))
		line.global_position = Vector2(0,0)


func _on_dungeon_selected(idx : int) -> void:
	LoadedRun.active_dungeon_idx = idx
	LoadedRun.active_dungeon_template = map_presets[map_biome].dungeon_template
	SceneManager.next_scene()


func _on_continued_to_next_stage() -> void:
	LoadedRun.stage += 1
	_reset()
	_generate_map()


func _reset() -> void:
	for i in range(dungeon_count + 1):
		dungeon_parent.get_child(i).queue_free()
