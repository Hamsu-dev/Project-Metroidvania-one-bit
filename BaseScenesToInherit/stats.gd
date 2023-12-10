class_name Stats
extends Node

@export var max_health = 0 : set = set_max_health
@export var knockback_force = 100.0 

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
	print(health)	
	health_changed.emit()
	if health <= 0:
		no_health.emit()
