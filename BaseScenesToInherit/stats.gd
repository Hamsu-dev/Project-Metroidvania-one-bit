class_name Stats
extends Node

@export var max_health = 3 : set = set_max_health
@onready var health = max_health : set = set_health

signal no_health
signal max_health_changed
signal health_changed(amount_changed)


func set_max_health(value):
	max_health = value
	max_health_changed.emit()


func set_health(value):
	var old_health = health
	health = clamp(value, 0, max_health)
	var change = health - old_health
	health_changed.emit(change)
	if health <= 0:
		no_health.emit()
