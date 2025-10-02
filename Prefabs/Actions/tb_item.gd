class_name TB_Item
extends TB_Action

@export var shop_icon : Texture2D
@export var shop_price : int

var count := 1 # number of items owned (of this type)
var cost := 0
var speed := INF
