class_name Hitbox
extends Area2D

@export var base_damage = 2  # Default to normal bullet base damage, change as needed in the editor

func _on_area_entered(hurtbox):
	if not hurtbox is Hurtbox: return

	var damage = GameStats.calculate_damage(base_damage)  # Calculate damage using base_damage
	hurtbox.take_hit(self, damage)

	if "Player" in hurtbox.get_groups():
		GameStats.reset_multiplier()
