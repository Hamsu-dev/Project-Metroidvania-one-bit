extends Control

@onready var full = $Full
@onready var empty = $Empty
@onready var progress_bar = $ProgressBar

func _ready():
	update_health_ui()
	update_max_health_ui()
	PlayerStats.health_changed.connect(update_health_ui)
	PlayerStats.max_health_changed.connect(update_max_health_ui)
	var game_stats_node = get_node("/root/GameStats")
	game_stats_node.damage_multiplier_updated.connect(_on_DamageMultiplierUpdated)

	progress_bar.min_value = 1.0
	progress_bar.max_value = GameStats.max_damage_multiplier

func update_health_ui():
	full.size.x = PlayerStats.health * 5 + 1


func update_max_health_ui():
	empty.size.x = PlayerStats.max_health * 5 + 1


func _on_DamageMultiplierUpdated(new_multiplier):
	progress_bar.value = new_multiplier
