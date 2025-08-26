class_name TentUI
extends Control

@export var shader_map : ColorRect = null
@export var shader_map_gradients : Array[Gradient] = []
@export var randomize_color_curve := false
@export var dungeon_icons : Array[Texture2D] = []
@export var dungeon_count := 3
@export var dungeon_position_x_offset := Vector2i(5, 5)
@export var dungeon_position_graph : Graph = null

var graph_offset = randi_range(0, 50)
var packed_dungeon := preload(Filepaths.MAP_DUNGEON)

func _ready() -> void:
	if shader_map:
		var height_map : NoiseTexture2D = shader_map.material.get_shader_parameter("height_map")
		height_map.noise.seed = randi()
		if randomize_color_curve:
			height_map.color_ramp = shader_map_gradients.pick_random()
		shader_map.material.set_shader_parameter("height_map", height_map)
	generate_dungeons(dungeon_count)
	self.visibility_changed.connect(_on_visibility_changed)


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("menu_back"):
			self.hide()


func generate_dungeons(count : int) -> void:
	for i in range(count):
		var new_dungeon := packed_dungeon.instantiate()
		new_dungeon.icon = dungeon_icons.pick_random()
		var c := 100 / count * (i + 1)
		new_dungeon.position.x = randi_range(c - dungeon_position_x_offset.x, c + dungeon_position_x_offset.y) - 100 / (2 * count) - new_dungeon.size.x / 2
		new_dungeon.position.y = get_dungeon_y(new_dungeon.position.x)
		new_dungeon.position -= Vector2(50, 50)
		get_node("Map").add_child(new_dungeon)


func get_dungeon_y(x : int) -> int:
	return int(dungeon_position_graph.sample([x, graph_offset]))
	#return int(32 * sin(2 * PI / 50 * (x + graph_offset)) + 50)


func _on_button_pressed() -> void:
	self.hide()


func _on_visibility_changed() -> void:
	if visible:
		get_node("Button").grab_focus()
