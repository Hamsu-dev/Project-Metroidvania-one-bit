extends Node

var kill_count = 0
var damage_multiplier = 1.0
var base_damage = 1
var max_damage_multiplier = 2.0


func increment_kill_count():
	kill_count += 1
	if damage_multiplier < max_damage_multiplier:
		damage_multiplier += 0.1 # Increase multiplier by 0.1 for each kill, but do not exceed the cap
	damage_multiplier = min(damage_multiplier, max_damage_multiplier)  # Enforce the cap
	print("Kill count: ", kill_count, ", Damage multiplier: ", damage_multiplier)
	

func reset_multiplier():
	if damage_multiplier > 2.0:
		damage_multiplier /= 2.0
	else:
		damage_multiplier = 1.0
	print("Damage multiplier reset to: ", damage_multiplier)

func calculate_damage() -> int:
	var calculated_damage = int(base_damage * damage_multiplier)
	return max(calculated_damage, 1)
