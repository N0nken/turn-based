extends Node

const STATUS_DURATIONS : Dictionary[String, int] = {
	"burn" : 1,
	"frozen" : 1,
	"electrified" : 1,
	"rage" : 1,
}
const STATUS_MAX_DURATIONS : Dictionary[String, int] = {
	"burn" : 10,
	"frozen" : 10,
	"electrified" : 10,
	"rage" : 1,
}

# Elemental
const BURN_FROZEN_EXPLOSION_DAMAGE := 0.10
const FROZEN_ELECTRICITY_BUFF := 1
const BURN_ELECTRICITY_DEBUFF := 1
const ELECTRIFIED_SKIP_CHANCE := 0.25

# Rage
const RAGE_DAMAGE_INCREASE_LIMIT := 0.35
const RAGE_DAMAGE_INCREASE := 1
const RAGE_DAMAGE_DECREASE_LIMIT := 0.3
const RAGE_DAMAGE_DECREASE := 1

# Gold drops
const GOLD_DROPS : Dictionary[String, int] = {
	"BOSS_BATTLE" : 5,
	"STANDARD" : 1,
}
