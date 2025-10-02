class_name TB_PlayerBattler
extends TB_Battler

func initialize_battler(battler_template : TB_BattlerTemplate) -> void:
	super(battler_template)
	
	_health = LoadedRun.player.health
