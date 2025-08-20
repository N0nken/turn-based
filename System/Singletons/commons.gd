extends Node

class Player:
	@export var battler_name := "Player"
	@export var max_health := 10
	@export var strength := 1
	@export var speed := 1
	@export var defense := 1
	@export var turn_plan_capacity := 10
	@export var health := 0
	@export var move_set : Array[String] = ["flee", "basic_attack", "quick_attack"]
	@export var backpack : Array[String] = []
	@export var gold := 0

var player := Player.new()
