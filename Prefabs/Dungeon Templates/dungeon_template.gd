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
@export var common_nodes : Array[DungeonNodeTemplate] = []
@export var rare_nodes : Array[DungeonNodeTemplate] = []
@export var legendary_nodes : Array[DungeonNodeTemplate] = []

@export var armor_for_sale : Array[Armor] = []
@export var weapons_for_sale : Array[Weapon] = []
@export var items_for_sale : Array[TB_Item] = []

var boss_node : DungeonNodeTemplate = preload("uid://1c8lv20ara24")
