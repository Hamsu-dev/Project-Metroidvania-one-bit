extends Powerup

func pickup():
	if not PlayerStats.is_ammo_full():
		super.pickup()
		PlayerStats.refill_ammo()  # Assuming refill_ammo is a method in PlayerStats
		print("Ammo refreshed")
	else:
		print("Ammo is already full, cannot pick up power-up")
