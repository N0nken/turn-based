class_name TB_Fight
extends DungeonActivity

enum _States {
	INITIALIZING,
	PLANNING,
	EXECUTING,
	ENDING,
}

const MAX_PLANNED_TURNS := 5

var _state := _States.INITIALIZING
var _enemy_battler_template : TB_BattlerTemplate

@onready var _player_battler : TB_PlayerBattler = get_node("Battlers/Player")
@onready var _enemy_battler : TB_AiBattler = get_node("Battlers/Enemy")
@onready var _action_timer : Timer = get_node("Timers/ActionTimer")
@onready var _end_screen_timer : Timer = get_node("Timers/EndScreenTimer")
@onready var _minigame : TB_Minigame = get_node("UI/Control/BattleViewport/Minigame")


func _ready() -> void:
	_setup()
	get_node("UI").setup()
	get_node("BattlerSprites/Enemy").setup()
	get_node("BattlerSprites/Player").setup()
	_init_planning_state()


func _setup() -> void:
	_player_battler.initialize_battler(LoadedRun.player.tb_template)
	if activity_args.is_boss_battle:
		_enemy_battler_template = LoadedRun.active_dungeon_template.faction.bosses.pick_random()
	else:
		_enemy_battler_template = LoadedRun.active_dungeon_template.faction.enemies.pick_random()
	_enemy_battler.initialize_battler(_enemy_battler_template)
	
	_player_battler.died.connect(_on_battler_died.bind(_player_battler))
	_player_battler.finished_planning.connect(_on_player_finished_planning)
	
	_enemy_battler.died.connect(_on_battler_died.bind(_enemy_battler))


func _input(event: InputEvent) -> void:
	if event.is_action("menu_dispute") and event.is_action_pressed("menu_dispute"):
		_player_battler.unplan_latest_turn()
		get_node("UI/Control/PlannedMoves").pop_action(true)


func _init_planning_state() -> void:
	_state = _States.PLANNING
	_player_battler.clear_plan()
	_enemy_battler.clear_plan()
	_enemy_battler.plan_turns()


func _execute_next_action() -> void:
	if not _player_battler.is_active() and not _enemy_battler.is_active():
		_end_round()
		return
	
	var fastest_battler : TB_Battler = null
	if not _player_battler.is_active():
		fastest_battler = _enemy_battler
	elif not _enemy_battler.is_active():
		fastest_battler = _player_battler
	else:
		var player_speed : int = _player_battler.next_action_speed()
		var enemy_speed : int = _enemy_battler.next_action_speed()
		
		if player_speed > enemy_speed:
			fastest_battler = _player_battler
		else:
			fastest_battler = _enemy_battler
	
	var next_action : TB_Action = fastest_battler.next_action()
	if next_action.target_self:
		next_action.target = fastest_battler
	else:
		next_action.target = _get_other_battler(fastest_battler)
	next_action.parent = fastest_battler
	
	
	if next_action is TB_Move and not fastest_battler is TB_PlayerBattler:
		var minigame_instructions : TB_MinigameInstructionSet = next_action.get_minigame_instructions()
		_minigame.visible = true
		print("minigame starting")
		if minigame_instructions:
			_minigame.start(next_action.get_minigame_instructions())
		else:
			_minigame.start(null, 5 * next_action.power + 5)
		var minigame_result : TB_Minigame.Result = await _minigame.ended
		print("minigame ended")
		_minigame.visible = false
		next_action.action(minigame_result.parry_efficiency)
	else:
		next_action.action(1.0)
	
	_action_timer.start(next_action.life_time)
	get_node("UI/Control/PlannedMoves").dequeue_action(fastest_battler == _player_battler)



func _end_round() -> void:
	_init_planning_state()


func _end_fight(player_won : bool) -> void:
	_state = _States.ENDING
	var battle_ended_node : TB_BattleEnded = get_node("UI/BattleEnded")
	if player_won:
		var gold_drop := 0
		if activity_args.is_boss_battle:
			gold_drop += Constants.GOLD_DROPS.BOSS_BATTLE
		else:
			gold_drop += Constants.GOLD_DROPS.STANDARD
		LoadedRun.player.gold += gold_drop
		LoadedRun.player.health = _player_battler.get_health()
		battle_ended_node.show_player_won(gold_drop)
	else:
		battle_ended_node.show_player_lost()
	_end_screen_timer.start()


func _get_other_battler(origin_battler : TB_Battler) -> TB_Battler:
	if origin_battler is TB_PlayerBattler:
		return _enemy_battler
	return _player_battler


func _on_player_finished_planning() -> void:
	_state = _States.EXECUTING
	_execute_next_action()


func _on_battler_died(battler : TB_Battler) -> void:
	if battler is TB_PlayerBattler:
		_end_fight(false)
	elif battler is TB_AiBattler:
		_end_fight(true)


func _on_action_timer_timeout() -> void:
	if _state == _States.EXECUTING:
		_execute_next_action()


func _on_end_screen_timer_timeout() -> void:
	get_node("UI/BattleEnded").visible = false
	activity_ended.emit()
