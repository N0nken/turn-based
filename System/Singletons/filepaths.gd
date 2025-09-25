extends Node

const SCENES : Dictionary[String, String] = {
	"main_menu" : "uid://db5c1iul8uydo",
	"map" : "uid://byx5c1c0bquj2",
	"dungeon" : "uid://cc8d2hi5vlou7",
	"loading_screen" : "uid://dqe73uyctw2so",
	"game_over" : "uid://mtumihg51bby",
}

# DUNGEON
const DUNGEON_ACTIVITES : Dictionary[String, String] = {
	"tb_fight" : "",
}
const DUNGEON_NODES : Dictionary[String, String] = {
	"early_exit" : "",
	"battle" : "",
}
const DUNGEON_TREE_PREFABS : Dictionary[String, String] = {
	"dungeon_node" : "uid://b3kra3ablwpel",
	"connection" : "uid://bs8cyjlysm8o1"
}
const TB_FIGHT_UI_NODES : Dictionary[String, String] = {
	"move_list_item" : "uid://eux26yax53op",
	"move_icon" : "uid://p076elcnrmrn",
}

# COMBAT
const ARMORS : Dictionary[String, String] = {
	"apprentices_robes" : "uid://cj15yuc7ktdao",
}
const WEAPONS : Dictionary[String, String] = {
	"apprentices_grimoire" : "uid://m60umhv8gg7x",
}
const ATTACKS : Dictionary[String, String] = {
	"flee" : "uid://43ehxfjvm01g",
	"basic_attack" : "uid://b66fyi0u1xscw",
	"quick_attack" : "uid://dmn2jv7qpcmu5",
	"ember" : "uid://debsgyd8uy0l6",
	"fireball" : "uid://b7e25378snpbd",
	"icicle" : "uid://d1hw2ms6fm8il",
	"ice_lance" : "uid://d3fppeagryklg",
	"shock" : "uid://caryfl10cikqi",
	"lightning" : "uid://b73vka806nri3",
	"rage" : "uid://fojb35fg2cbl",
}
const ITEMS : Dictionary[String, String] = {
	
}
const ENEMIES : Dictionary[String, String] = {
	"weak_goblin" : "uid://br37vntb3dyh0",
}
const MISC_ACTIONS : Dictionary[String, String] = {
	"stunned" : "uid://2vuhobrpjp4x",
}

# MAP
const MAP_DUNGEON := "uid://18kpyukf61f4"

# MISC
const TEXTURE_NOT_FOUND := "uid://ckkl5netvo8e1"
const TOTALLY_SUPER_IMPORTANT_COCONUT_PNG_DO_NOT_REMOVE := "uid://kf13nfj10e37"
const PACKED_CLOUD := "uid://cxx6piymain34"
const SS_INPUT_ICONS := "uid://dqqhuqgdi7hwh" # add the rest of the buttons
const UI_INPUT_ICONS : Dictionary[String, String] = {
	"keyboard" : "uid://chfftpjn5dqor",
	"controller" : "uid://0pea7mnq3nvk",
}
const DAMAGE_FORMULA := "uid://bau035drpimm2"
const STATUS_EFFECT_ICON := "uid://3o8npagistqc"
