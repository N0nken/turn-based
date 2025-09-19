class_name TB_Move
extends TB_Action

enum Speeds {
	ZERO,
	LOW,
	LOW_MED,
	MEDIUM,
	MED_HIGH,
	HIGH,
}

enum Costs {
	ZERO,
	LOW,
	LOW_MED,
	MEDIUM,
	MED_HIGH,
	HIGH,
}

@export var cost := Costs.LOW # turn plan capacity cost
@export var speed := Speeds.LOW # determines turn order
