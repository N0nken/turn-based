extends Node

var health := 0
var max_health := 10
var strength := 1
var speed := 1
var turn_plan_capacity := 10
var battler_name := "Player"
var move_set : Array[String] = ["flee", "basic_attack", "quick_attack"]
var backpack : Array[String] = []
