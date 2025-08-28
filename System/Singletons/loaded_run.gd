extends Node


enum MapBiomes {
	MOUNTAINOUS_FOREST,
	VOLCANIC_FOREST,
	FROZEN_LAKES,
	SNOWY_PEAKS,
}

# PLAYER
var player := Player.new()

# MAP
var map_biome := MapBiomes.MOUNTAINOUS_FOREST
var map_noise_seed := 0
var map_dungeons : Array[Dungeon] = []
var map_generated := false


func _ready() -> void:
	player.health = player.max_health


class Player:
	var battler_name := "Player"
	var max_health := 10
	var strength := 1
	var speed := 1
	var defense := 1
	var turn_plan_capacity := 10
	var health := 0
	var move_set : Array[String] = ["flee", "basic_attack", "quick_attack"]
	var backpack : Array[String] = []
	var gold := 0


class Dungeon:
	var state := MapDungeon.States.LOCKED
	var position := Vector2.ZERO
	var template_name := ""
