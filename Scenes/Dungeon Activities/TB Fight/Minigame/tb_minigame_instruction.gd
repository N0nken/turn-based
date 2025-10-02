class_name TB_MinigameInstruction
extends Resource


@export var north_active := false
@export var east_active := false
@export var south_active := false
@export var west_active := false

@export var north_color : TB_Minigame.SquareColors
@export var east_color : TB_Minigame.SquareColors
@export var south_color : TB_Minigame.SquareColors
@export var west_color : TB_Minigame.SquareColors

var active_directions : Dictionary[TB_Minigame.OriginDirections, bool] = {
	TB_Minigame.OriginDirections.NORTH : false,
	TB_Minigame.OriginDirections.EAST : false,
	TB_Minigame.OriginDirections.SOUTH : false,
	TB_Minigame.OriginDirections.WEST : false,
}

var colors : Dictionary[TB_Minigame.OriginDirections, TB_Minigame.SquareColors] = {
	TB_Minigame.OriginDirections.NORTH : TB_Minigame.SquareColors.NULL,
	TB_Minigame.OriginDirections.EAST : TB_Minigame.SquareColors.NULL,
	TB_Minigame.OriginDirections.SOUTH : TB_Minigame.SquareColors.NULL,
	TB_Minigame.OriginDirections.WEST : TB_Minigame.SquareColors.NULL,
}

func _init() -> void:
	active_directions[TB_Minigame.OriginDirections.NORTH] = north_active
	active_directions[TB_Minigame.OriginDirections.EAST] = east_active
	active_directions[TB_Minigame.OriginDirections.SOUTH] = south_active
	active_directions[TB_Minigame.OriginDirections.WEST] = west_active
	
	colors[TB_Minigame.OriginDirections.NORTH] = north_color
	colors[TB_Minigame.OriginDirections.EAST] = east_color
	colors[TB_Minigame.OriginDirections.SOUTH] = south_color
	colors[TB_Minigame.OriginDirections.WEST] = west_color
