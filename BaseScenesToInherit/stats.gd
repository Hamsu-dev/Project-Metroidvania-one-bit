class_name Stats
extends Node

var base_max_health = 3 

@export var max_health = 3 : set = set_max_health
@onready var health = max_health : set = set_health

signal no_health
signal health_changed
signal max_health_changed


func set_max_health(value):
	if max_health != value:
		max_health = value
		health = max_health
		max_health_changed.emit()
	print("Max health set to:", max_health)

func set_health(value):
	health = clamp(value, 0, max_health)
	health_changed.emit()
	if health <= 0: no_health.emit()
