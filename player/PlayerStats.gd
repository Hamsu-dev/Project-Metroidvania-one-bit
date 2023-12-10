extends Stats

@export var max_missiles = 0: set = set_max_missiles

@onready var missiles = max_missiles : set = set_missiles

# Blaster stats
var fire_rate: float = 0.1
var reload_speed: float = 2.0
var ammo_capacity: int = 10
var current_ammo: int = ammo_capacity
var is_reloading: bool = false

signal bullets_changed(current_ammo)
signal reloading_status_changed(is_reloading)
signal max_missiles_changed
signal missiles_changed

func set_max_missiles(value):
	max_missiles = value
	max_missiles_changed.emit()

func set_missiles(value):
	missiles = clampi(value, 0, max_missiles)
	missiles_changed.emit()

func change_ammo(value: int):
	current_ammo = value
	emit_signal("bullets_changed", current_ammo)

func set_reloading_status(status: bool):
	is_reloading = status
	emit_signal("reloading_status_changed", is_reloading)

func refill_ammo():
	change_ammo(ammo_capacity)  # Resets current ammo to max capacity

func is_ammo_full() -> bool:
	return current_ammo == ammo_capacity
