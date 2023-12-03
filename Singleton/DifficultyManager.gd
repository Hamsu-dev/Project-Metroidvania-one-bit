# DifficultyManager.gd
extends Node

var difficulty_level = 1
var time_since_last_damage = 0.0
var grace_period = 0.0  # Start with 0 grace period
var increase_difficulty_interval = 1.0  # Seconds without damage to increase difficulty

signal difficulty_changed(new_difficulty_level)

func _process(delta):
	if grace_period > 0:
		grace_period -= delta  # Decrease grace period timer
		return  # Skip increasing difficulty while in grace period

	time_since_last_damage += delta
	adjust_difficulty_based_on_performance()

func adjust_difficulty_based_on_performance():
	if time_since_last_damage > increase_difficulty_interval:
		increase_difficulty()

func increase_difficulty():
	difficulty_level += 1
	time_since_last_damage = 0
	# Update game elements with new difficulty settings
	emit_signal("difficulty_changed", difficulty_level)

func register_damage():
	time_since_last_damage = 0
	grace_period = 30.0  # Set grace period to 30 seconds upon taking damage
