extends Powerup

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	set_process(true)

func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":  # Replace with the appropriate condition to identify the player
			if not PlayerStats.is_ammo_full():
				pickup()
				break  # Exit the loop after picking up to avoid multiple pickups

func pickup():
	if not PlayerStats.is_ammo_full():
		super.pickup()
		PlayerStats.refill_ammo()  # Assuming refill_ammo is a method in PlayerStats
		print("Ammo refreshed")
		queue_free()  # Ensure the pickup is 'consumed'
	else:
		print("Ammo is already full, cannot pick up power-up")
