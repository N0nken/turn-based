class_name TB_Minigame
extends Control

signal ended(result : Result)

enum OriginDirections {
	NORTH,
	EAST,
	SOUTH,
	WEST,
}

enum SquareColors {
	DEFAULT,
	PARRYABLE,
	INVERTED,
	NULL,
}

const MAP_SIZE := 7

static var square_color_hex_translations : Dictionary[SquareColors, String] = {
	SquareColors.DEFAULT : "#ff0000",
	SquareColors.PARRYABLE : "#ff00ff",
	SquareColors.INVERTED : "#00ff00",
}

@export var step_duration := 0.1

var randomize_instructions := false
var instructions : TB_MinigameInstructionSet
var ongoing := false
var active_squares : Array[Square] = []
var instructions_left := 0

var hits := 0
var total_squares := 0
var parries := 0
var total_parries := 0

var color_rect_template : PackedScene = preload(Filepaths.TB_MINIGAME_COLOR_RECT)

@onready var horizontal_container : HBoxContainer = get_node("MarginContainer/ScrollContainer2/HBoxContainer")
@onready var vertical_container : VBoxContainer = get_node("MarginContainer/ScrollContainer/VBoxContainer")
@onready var tick_rate_timer : Timer = get_node("TickRate")
@onready var square_container : Control = get_node("SquareContainer")

#func _ready() -> void:
	#start(null, 10)


func start(instruction_set : TB_MinigameInstructionSet = null, randomized_count : int = 0) -> void:
	ongoing = true
	if instruction_set == null:
		instructions_left = randomized_count
		randomize_instructions = true
	else:
		instructions = instruction_set
		instructions.cleared.connect(_on_instructions_cleared)
	tick_rate_timer.start()


func _on_tick_rate_timeout() -> void:
	if ongoing or active_squares.size() > 0:
		tick_rate_timer.start()
	else:
		var hit_efficiency := float(hits) / float(total_squares)
		var parry_efficiency := 1.0 - float(parries) / float(total_parries)
		var result := Result.new(hit_efficiency, parry_efficiency)
		ended.emit(result)
		return
	
	for square in active_squares:
		square.progress()
	_next_instruction()
	_update_visuals()
	_clear_dead_squares()


func _on_instructions_cleared() -> void:
	ongoing = false


func _next_instruction() -> void:
	if instructions_left == 0:
		ongoing = false
		return
		
	if randomize_instructions:
		var square_count := randi_range(1,3);
		var available_directions : Array[int]
		available_directions.assign(OriginDirections.values().duplicate())
		var available_colors : Array[int]
		available_colors.assign(SquareColors.values().duplicate())
		for i in range(0, square_count):
			_spawn_square(available_directions.pop_at(randi_range(0, available_directions.size() - 1)), 
				available_colors.pop_at(randi_range(0, available_colors.size() - 1)))
		instructions_left -= 1
		return
	var instruction : TB_MinigameInstruction = instructions.next_instruction()
	for direction in OriginDirections.values():
		if instruction.active_directions[direction]:
			_spawn_square(direction, instruction.colors[direction])
	instructions_left = instructions.instructions_left()


func _spawn_square(direction : OriginDirections, color : SquareColors) -> void:
	if color == SquareColors.NULL:
		match randi_range(0, 2):
			0: color = SquareColors.DEFAULT
			1: color = SquareColors.PARRYABLE
			2: color = SquareColors.INVERTED
	var new_color_rect : ColorRect = color_rect_template.instantiate()
	new_color_rect.color = square_color_hex_translations[color]
	square_container.add_child(new_color_rect)
	var new_square := Square.new(new_color_rect, direction, color)
	active_squares.append(new_square)
	total_squares += 1


func _update_visuals() -> void:
	for square in active_squares:
		var target_container : BoxContainer
		if square.origin == OriginDirections.NORTH or square.origin == OriginDirections.SOUTH:
			target_container = vertical_container
		else:
			target_container = horizontal_container
		var target_panel : Panel = target_container.get_child(square.get_progress())
		var new_position = target_panel.global_position# + target_panel.size / 2.0
		
		if not (square.get_progress() == 0 or square.get_progress() == 6):
			var distance_tween := get_tree().create_tween()
			distance_tween.tween_property(square.node, "global_position", new_position, step_duration)
		else:
			square.node.global_position = new_position
			square.node.scale = Vector2.ZERO
			var scale_tween := get_tree().create_tween()
			scale_tween.tween_property(square.node, "scale", Vector2.ONE, step_duration / 2.0)


func _clear_dead_squares() -> void:
	var i := 0
	while i < active_squares.size():
		if (
			(active_squares[i].get_progress() == 4 and 
			(active_squares[i].origin == OriginDirections.NORTH or active_squares[i].origin == OriginDirections.WEST)
		) or (
			(active_squares[i].get_progress() == 2 and 
			(active_squares[i].origin == OriginDirections.EAST or active_squares[i].origin == OriginDirections.SOUTH))
		)):
			var killed_square : Square = active_squares.pop_at(i)
			killed_square.node.call_deferred("queue_free")
		else:
			i += 1


class Square:
	var node : ColorRect
	var origin : OriginDirections
	var _progress : int
	var color : SquareColors
	
	func _init(color_rect : ColorRect, direction : OriginDirections, square_color : SquareColors) -> void:
		self.node = color_rect
		self.origin = OriginDirections.values()[direction]
		self.color = square_color
		if direction == OriginDirections.NORTH or direction == OriginDirections.WEST:
			self._progress = 0
		else:
			self._progress = 6
	
	func progress() -> void:
		if self.origin == OriginDirections.NORTH or self.origin == OriginDirections.WEST:
			self._progress += 1
		else:
			self._progress -= 1
	
	
	func get_progress() -> int:
		return self._progress


class Result:
	var hit_efficiency : float
	var parry_efficiency : float
	
	func _init(hit : float, parry : float):
		self.hit_efficiency = hit
		self.parry_efficiency = parry
