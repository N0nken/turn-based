extends Node

# GAME STATE
var stage := 0

# PLAYER
var player := Player.new()

# MAP
var map_biome := Map.Biomes.MOUNTAINOUS_FOREST
var map_noise_seed := 0
var map_dungeons : Array[Dungeon] = []
var map_generated := false

# DUNGEON
var active_dungeon_idx := 0
var active_dungeon_template : DungeonTemplate = load("uid://ds7yu0m6t3fdx") # default goblin dungeon


func reset() -> void:
	stage = 0
	
	player = Player.new()
	
	map_biome = Map.Biomes.MOUNTAINOUS_FOREST
	map_noise_seed = 0
	map_dungeons = []
	map_generated = false
	
	active_dungeon_idx = 0


func clear_active_dungeon() -> void:
	map_dungeons[active_dungeon_idx].state = MapDungeon.States.CLEARED


func next_stage() -> void:
	stage += 1
	pass


class Player:
	var tb_template : TB_BattlerTemplate
	var health : int
	var backpack : Array[TB_Item]
	var gold : int
	
	func _init() -> void:
		self.tb_template = TB_BattlerTemplate.new()
		self.tb_template.name = "Player"
		self.tb_template.armor = load(Filepaths.ARMORS.apprentices_robes)
		self.tb_template.weapon = load(Filepaths.WEAPONS.apprentices_grimoire)
		self.health = self.tb_template.armor.health
		self.backpack = []
		self.gold = 0


class Dungeon:
	var state := MapDungeon.States.LOCKED
	var position := Vector2.ZERO
	var template_name := ""
