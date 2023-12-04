# DropManager
extends Node

var possible_drops = [
	{"item": preload("res://Upgrades/AttackUpgrade.gd"), "chance": 0.1}
	# Add more items with their chances of dropping here
	# {"item": preload("res://path/to/CoinDrop.tscn"), "chance": 0.5},
]

func get_random_drop():
	var total_chance = 0.0
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for drop in possible_drops:
		total_chance += drop.chance

	var roll = rng.randf() * total_chance
	var cumulative_chance = 0.0

	for drop in possible_drops:
		cumulative_chance += drop.chance
		if roll <= cumulative_chance:
			return drop.item.instantiate()
	return null
