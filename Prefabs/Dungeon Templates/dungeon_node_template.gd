class_name DungeonNodeTemplate
extends Resource

@export var name := ""
## Icon to show on node in dungeon tree
@export var icon : Texture2D = null
## UID to target scene
@export var target_activity : String = ""
## Eventual arguments to be passed to the scene
@export var activity_args : Dictionary
