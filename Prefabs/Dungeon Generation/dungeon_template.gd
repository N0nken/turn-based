class_name DungeonTemplate
extends Resource

@export var faction : EnemyFaction = null
@export var max_tree_width : int = 0 
@export var tree_depth : Dictionary[String,int] = {
	"min" : 1,
	"max" : 1
}
@export var branch_count : Dictionary[String,int] = {
	"min" : 1,
	"max" : 1
}
@export var double_branch_chance : float = 0.5
@export var dungeon_nodes : Array[DungeonNodeTemplate] = []
