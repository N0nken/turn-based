class_name LinkedList
extends RefCounted

var _head : _ListNode
var _tail : _ListNode
var _size : int

func _init() -> void:
	_head = _ListNode.new()
	_tail = _head
	_size = 0


func append(data : Variant) -> void:
	add_at(data, -1)


func add_at(data : Variant, idx : int) -> void:
	var parent_node : _ListNode 
	if idx < 0:
		parent_node = _get_node_at(idx).parent
	else:
		parent_node = _get_node_at(idx).parent
	var child_node : _ListNode = parent_node.child # Remember next node
	parent_node.child = _ListNode.new(data, parent_node) # Replace old node at same idx
	child_node.parent = parent_node.child # Set old node parent to new node
	parent_node.child.child = child_node # Set old node as child to new node


func get_at() -> Variant:
	return


func remove_at() -> void:
	pass
	

func pop_at() -> Variant:
	return


func _get_node_at(idx : int) -> _ListNode:
	if _size == 0:
		return null
	var current_node : _ListNode
	if idx < 0:
		current_node = _tail
		for i in range(idx+1, 0):
			current_node = current_node.parent
	else:
		current_node = _head.child
		for i in range(0, idx):
			current_node = current_node.child
	return current_node

class _ListNode:
	var parent : _ListNode
	var child : _ListNode
	var data : Variant
	
	
	func _init(value : Variant = null, parent_node : _ListNode = null) -> void:
		self.child = null
		self.parent = parent_node
		self.data = value
