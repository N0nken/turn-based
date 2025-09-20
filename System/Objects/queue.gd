class_name Queue
extends RefCounted

var _head : _QueueNode
var _tail : _QueueNode
var _size := 0


func _init() -> void:
	_head = _QueueNode.new()
	_tail = _head


## Get and remove the next element in queue
func next() -> Variant:
	if _head.child:
		var next_node := _head.child
		_head.child = next_node.child
		_size -= 1
		if next_node.child:
			next_node.child.parent = _head
		else:
			_tail = _head
		return next_node.data
	return null


## Append an element at the end of the queue.
func append(variant : Variant) -> void:
	var new_node = _QueueNode.new(variant, _tail)
	_tail.child = new_node
	_tail = new_node
	_size += 1


## Get the next element in queue without removing it
func peek() -> Variant:
	return _head.child.data


func _peek_node() -> _QueueNode:
	return _head.child


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
