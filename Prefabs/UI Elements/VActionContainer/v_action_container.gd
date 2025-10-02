class_name VActionContainer
extends VBoxContainer

@export var packed_action_list_item : PackedScene = preload(Filepaths.TB_FIGHT_UI_NODES.move_list_item)


func load_action_set(action_set : Array) -> void:
	clear_action_set()
	
	# Instantiate items
	for action in action_set:
		var new_action_list_item : TB_ActionListItem = packed_action_list_item.instantiate()
		new_action_list_item.action = action
		add_child(new_action_list_item)
	
	# Correct focus
	for i in range(0, get_child_count()):
		if i == 0:
			get_child(i).focus_neighbor_bottom = get_child(i+1).get_path()
		elif i == get_child_count() - 1:
			get_child(i).focus_neighbor_top = get_child(i-1).get_path()
		else:
			get_child(i).focus_neighbor_top = get_child(i-1).get_path()
			get_child(i).focus_neighbor_bottom = get_child(i+1).get_path()


func clear_action_set() -> void:
	for i in range(get_child_count()):
		remove_child(get_child(0))
