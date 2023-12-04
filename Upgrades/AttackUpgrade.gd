class_name AttackUpgrade
extends BlasterUpgrade

var additional_damage: int = 2

func apply_to_bullet(bullet: Node2D) -> void:
	# Assuming the bullet has a child node of type Hitbox called "Hitbox"
	var hitbox = bullet.get_node("Hitbox")
	if hitbox:
		hitbox.add_damage(additional_damage)
