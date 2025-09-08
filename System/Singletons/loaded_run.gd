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
	var battler_name := "Player"
	var max_health := 10
	var strength := 1
	var speed := 1
	var defense := 1
	var turn_plan_capacity := 10
	var health := 0
	var move_set : Array[String] = ["flee", "basic_attack", "quick_attack", "flee"]
	var backpack : Array[String] = []
	var gold := 0

	func _init() -> void:
		self.health = self.max_health


class Dungeon:
	var state := MapDungeon.States.LOCKED
	var position := Vector2.ZERO
	var template_name := ""
