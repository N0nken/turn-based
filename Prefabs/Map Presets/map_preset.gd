class_name MapPreset
extends Resource

@export var color_gradient : Gradient
@export var dungeon_icon : Texture2D
@export var dungeon_template : DungeonTemplate
@export var height_multiplier : float
## 1 for complete darkness, 0 for no darkness, 0.5 for default darkness
@export_range(0,1) var darkness_scale : float = 0.5
