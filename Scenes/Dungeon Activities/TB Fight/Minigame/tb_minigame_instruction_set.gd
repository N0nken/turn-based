class_name TB_MinigameInstructionSet
extends Resource

signal cleared

@export var _instructions : Array[TB_MinigameInstruction] = []
## Rate of which to go through the instructions
@export var tick_rate : float = 0.5

var instructions : Queue


func generate_queue() -> void:
	instructions = Queue.new()
	for instruction in _instructions:
		instructions.append(instruction)
	instructions.emptied.connect(cleared.emit)


func next_instruction() -> TB_MinigameInstruction:
	return instructions.next()


func instructions_left() -> int:
	return instructions.size()
