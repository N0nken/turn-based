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

# POTIONS
const POTION_OF_HEALING_RATIO := 0.2

# DUNGEON TEMPLATE NODE CHANCES
const COMMON_NODE_RATIO : float = 70.0
const RARE_NODE_RATIO : float = 20.0
const LEGENDARY_NODE_RATIO : float = 10.0

const TOTAL_NODE_RATIO : float = COMMON_NODE_RATIO + RARE_NODE_RATIO + LEGENDARY_NODE_RATIO

# if randf() < RARITY_CHANCE (+ lesser rarities) --> RARITY
# if randf() < COMMON_CHANCE --> COMMON
# elif randf() < COMMON_CHANCE + RARE_CHANCE --> RARE
# elif randf() < COMMON_CHANCE + RARE_CHANCE + LEGENDARY_CHANCE --> LEGENDARY
const COMMON_NODE_CHANCE : float = COMMON_NODE_RATIO / TOTAL_NODE_RATIO 
const RARE_NODE_CHANCE : float = RARE_NODE_RATIO / TOTAL_NODE_RATIO + COMMON_NODE_CHANCE
const LEGENDARY_NODE_CHANCE : float = LEGENDARY_NODE_RATIO / TOTAL_NODE_RATIO + RARE_NODE_CHANCE
