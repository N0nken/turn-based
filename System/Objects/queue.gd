class_name Queue
extends RefCounted

var queue_head : _QueueNode
var _size := 0

func _init() -> void:
	queue_head = _QueueNode.new()
	queue_head.parent = queue_head


## Get and remove the next element in queue
func next() -> Variant:
	var next_node = queue_head.child
	queue_head.child = next_node.child
	_size -= 1
	return next_node.data


## Append an element at the end of the queue.
func append(variant : Variant) -> void:
	var tail := queue_head.parent
	var new_node = _QueueNode.new(variant, tail)
	tail.child = new_node
	queue_head.parent = new_node
	_size += 1


## Get the next element in queue without removing it
func peek() -> _QueueNode:
	return queue_head.child


## Get the size of the queue
func size() -> int:
	return _size


class _QueueNode:
	var parent : _QueueNode
	var child : _QueueNode
	var data : Variant
	
	func _init(data : Variant = null, parent : _QueueNode = null) -> void:
		self.child = null
		self.parent = parent
		self.data = data
