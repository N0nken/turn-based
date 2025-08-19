class_name DungeonTree
extends Node

enum GenerationPhases {
	PAUSED,
	CREATING_NODES,
	ADOPTING_NODES,
	TRANSLATING_NODES,
	DRAWING_FAMILY_CONNECTIONS,
	CORRECTING_FOCUS_NEIGHBORS,
}

@export var layer_position_diffs := Vector2.ZERO
@export var layer_position_offset_min := Vector2.ZERO
@export var layer_position_offset_max := Vector2.ZERO

var packed_dungeon_node := preload(Filepaths.DUNGEON_TREE_PREFABS["dungeon_node"])
var packed_dungeon_node_connection := preload(Filepaths.DUNGEON_TREE_PREFABS["connection"])
var generation_done_mutex := Mutex.new()
var generation_done := true
var generation_thread := Thread.new()
var current_generation_phase := GenerationPhases.PAUSED
var active_template : DungeonTemplate = null


func _process(_delta : float) -> void:
	if current_generation_phase != GenerationPhases.PAUSED:
		match current_generation_phase:
			GenerationPhases.CREATING_NODES:
				_generate_nodes(active_template)
				current_generation_phase = GenerationPhases.ADOPTING_NODES
			GenerationPhases.ADOPTING_NODES:
				_adopt_child_nodes()
				current_generation_phase = GenerationPhases.TRANSLATING_NODES
			GenerationPhases.TRANSLATING_NODES:
				_translate_nodes(active_template)
				current_generation_phase = GenerationPhases.DRAWING_FAMILY_CONNECTIONS
			GenerationPhases.DRAWING_FAMILY_CONNECTIONS:
				_draw_family_connections()
				current_generation_phase = GenerationPhases.CORRECTING_FOCUS_NEIGHBORS
			GenerationPhases.CORRECTING_FOCUS_NEIGHBORS:
				_correct_focus_neighbors()
				current_generation_phase = GenerationPhases.PAUSED
				get_node("DungeonNodes/Layer0/SpawnNode").get_node("Button").grab_focus()
				get_node("LoadingScreen").visible = false
				get_node("DungeonNodes/Layer0/SpawnNode").clear()
				get_node("DungeonNodes/Layer0/SpawnNode").activate_children()

func generate_dungeon(template : DungeonTemplate) -> void:
	get_node("LoadingScreen").visible = true
	current_generation_phase = GenerationPhases.CREATING_NODES
	active_template = template


func _generate_nodes(template : DungeonTemplate) -> void:
	var dungeon_head := get_node("DungeonNodes")
	var total_depth := randi_range(template.tree_depth.min, template.tree_depth.max)
	var previous_layer : Array[Node] = dungeon_head.get_node("Layer0").get_children()
	var average_branch_count := (template.branch_count.min + template.branch_count.max) / 2
	for depth in range(1,total_depth+2):
		var total_new_nodes := previous_layer.size()
		if depth < total_depth * 2 / 3:
			var minimum_change := 0
			if depth > 2:
				minimum_change = 1
			total_new_nodes += randi_range(minimum_change, average_branch_count)
		elif depth >= total_depth * 2 / 3:
			var minimum_change := 0
			if depth > total_depth - 2:
				minimum_change = 0
			total_new_nodes -= randi_range(minimum_change, average_branch_count)
		else:
			total_new_nodes = 1
		if total_new_nodes <= 0:
			total_new_nodes *= -1 + 1
		total_new_nodes = clamp(total_new_nodes, 1, template.max_tree_width)
		var new_layer_head := Control.new()
		new_layer_head.name = "Layer"+str(depth)
		new_layer_head.position.y = -depth * layer_position_diffs.y
		dungeon_head.add_child(new_layer_head)
		for i in range(total_new_nodes):
			# Initialise new node
			var new_node : DungeonNode = packed_dungeon_node.instantiate()
			new_node.depth = depth
			new_node.activity_selected.connect(get_parent().get_node("DungeonActivityManager")._on_activity_selected)
			new_node.target_camera = get_node("Camera2D")
			new_layer_head.add_child(new_node)
		previous_layer = new_layer_head.get_children()


func _adopt_child_nodes() -> void:
	var dungeon_head := get_node("DungeonNodes")
	# Connect parents-children
	for i in range(dungeon_head.get_child_count()-1):
		var parent_layer_head := dungeon_head.get_child(i)
		var children_layer_head := dungeon_head.get_child(i+1)
		var parent_count := parent_layer_head.get_child_count()
		var child_count := children_layer_head.get_child_count()
		if child_count > parent_count:
			# Get orphans
			var orphan_nodes : Array[Node] = children_layer_head.get_children()
			var children_per_parent : int = child_count / parent_count
			# Adopt orphans
			for parent in parent_layer_head.get_children():
				for n in range(children_per_parent):
					var selected_orphan : DungeonNode = orphan_nodes.pop_at(randi_range(0, orphan_nodes.size()-1))
					parent.branches.append(selected_orphan)
					selected_orphan.parents.append(parent)
			# Force adopt unwanted orphans
			if orphan_nodes.size() > 0:
				for orphan in orphan_nodes:
					var parent : DungeonNode = parent_layer_head.get_children()[randi_range(0, parent_count-1)]
					parent.branches.append(orphan)
					orphan.parents.append(parent)
		else:
			var parents : Array[Node] = parent_layer_head.get_children()
			var parents_per_child : int = parent_count / child_count
			# Single parents adopt orphans
			for orphan in children_layer_head.get_children():
				for n in range(parents_per_child):
					var selected_parent : DungeonNode = parents.pop_at(randi_range(0, parents.size()-1))
					selected_parent.branches.append(orphan)
					orphan.parents.append(selected_parent)
			if parents.size() > 0:
				for parent in parents:
					var orphan : DungeonNode = children_layer_head.get_children()[randi_range(0, child_count-1)]
					parent.branches.append(orphan)
					orphan.parents.append(parent)
		_reorder_children_after_parents(parent_layer_head)


func _translate_nodes(template : DungeonTemplate) -> void:
	var dungeon_head := get_node("DungeonNodes")
	var total_depth := randi_range(template.tree_depth.min, template.tree_depth.max)
	# Move nodes and apply templates
	for i in (dungeon_head.get_child_count()):
		var layer_head := dungeon_head.get_child(i)
		if layer_head == dungeon_head.get_node("Layer0"):
			continue
		var x_min : int = layer_head.get_child_count() / -2 * layer_position_diffs.x
		if layer_head.get_child_count() % 2 == 0:
			x_min += layer_position_diffs.x/2
		var layer_head_child_count := layer_head.get_child_count()
		for n in range(layer_head_child_count):
			var node : DungeonNode = layer_head.get_child(n)
			node.position.x = x_min + layer_position_diffs.x * n #+ randf_range(layer_position_offset_min.x, layer_position_offset_max.x)
			node.position.y = randf_range(layer_position_offset_min.y, layer_position_offset_max.y)
			if i < dungeon_head.get_child_count()-1:
				var next_layer_child_count := dungeon_head.get_child(i+1).get_child_count()
				if randf() < template.double_branch_chance and i < total_depth:
					if n < layer_head_child_count / 2:
						node.branches.append(dungeon_head.get_child(i+1).get_children()[randi_range(0, next_layer_child_count/2 - 1)])
					else:
						node.branches.append(dungeon_head.get_child(i+1).get_children()[randi_range(next_layer_child_count/2, next_layer_child_count-1)])
			var selected_template = template.dungeon_nodes.pick_random()
			if node.branches.size() == 0:
				#if node.depth != total_depth:
					#node.node_template = load(Filepaths.DUNGEON_NODES["early_exit"])
				#	node.node_template = null
				#else:
					# node is boss_node
				pass
			else:
				if selected_template.name == "exit":
					node.branches = []
			node.node_template = selected_template
			node.update_icon()


func _draw_family_connections() -> void:
	var dungeon_head := get_node("DungeonNodes")
	for i in range(dungeon_head.get_child_count()-1):
		var layer_head : Control = dungeon_head.get_child(i)
		for parent in layer_head.get_children():
			for child in parent.branches:
				_add_node_connection(parent, child)


func _correct_focus_neighbors() -> void:
	var dungeon_head = get_node("DungeonNodes")
	for layer in dungeon_head.get_children():
		var layer_child_count := layer.get_child_count()
		for i in (layer_child_count):
			var node : DungeonNode = layer.get_child(i)
			var node_button : Button = node.get_node("Button")
			node_button.focus_neighbor_bottom = node_button.get_path()
			node_button.focus_neighbor_top = node_button.get_path()
			node_button.focus_neighbor_left = node_button.get_path()
			node_button.focus_neighbor_right = node_button.get_path()
			node_button.focus_next = node_button.get_path()
			node_button.focus_previous = node_button.get_path()
			if node.branches.size() > 0:
				node_button.focus_neighbor_top = node.branches[0].get_node("Button").get_path()
			if node.parents.size() > 0:
				node_button.focus_neighbor_bottom = node.parents[0].get_node("Button").get_path()
			if layer_child_count > 1:
				if i == 0:
					node_button.focus_neighbor_right = layer.get_child(1).get_node("Button").get_path()
				elif i == layer_child_count - 1:
					node_button.focus_neighbor_left = layer.get_child(-2).get_node("Button").get_path()
				elif layer_child_count > 2:
					node_button.focus_neighbor_left = layer.get_child(i-1).get_node("Button").get_path()
					node_button.focus_neighbor_right = layer.get_child(i+1).get_node("Button").get_path()


func _add_node_connection(parent : DungeonNode, child : DungeonNode) -> void:
	var new_connection : DungeonNodeConnection = packed_dungeon_node_connection.instantiate()
	new_connection.width = 2
	new_connection.add_point(parent.get_node("ConnectionTop").global_position)
	new_connection.add_point(child.get_node("ConnectionBottom").global_position)
	new_connection.parent = parent
	new_connection.child = child
	child.parent_connections.append(new_connection)
	get_node("Lines").add_child(new_connection)
	child.deactivate()


func _reorder_children_after_parents(parent_layer_head) -> void:
	for parent in parent_layer_head.get_children():
		for child in parent.branches:
			child.get_parent().move_child(child, -1)


func _on_dungeon_activity_manager_activity_started() -> void:
	self.visible = false


func _on_dungeon_activity_manager_activity_ended(node : DungeonNode) -> void:
	self.visible = true
	node.branches[0].get_node("Button").grab_focus()
	get_node("Camera2D").make_current()
	node.clear()
	node.activate_children()
	for locked_node in get_node("DungeonNodes").get_child(node.depth).get_children():
		if not locked_node.cleared:
			locked_node.lock()
