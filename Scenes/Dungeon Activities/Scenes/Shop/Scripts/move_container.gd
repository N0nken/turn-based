extends VBoxContainer

@export var packed_action_list_item : PackedScene = preload(Filepaths.TB_FIGHT_UI_NODES.move_list_item)


func load_move_set(weapon : Weapon) -> void:
	clear_move_set()
	var move_set : Array[TB_Move] = weapon.move_set
	
	for move in move_set:
		var new_action_list_item : TB_ActionListItem = packed_action_list_item.instantiate()
		new_action_list_item.action = move
		add_child(new_action_list_item)
	

func clear_move_set() -> void:
	for i in range(get_child_count()):
		remove_child(get_child(0))
