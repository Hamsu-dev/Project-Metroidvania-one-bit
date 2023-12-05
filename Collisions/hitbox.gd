class_name Hitbox
extends Area2D

@export var damage = 1

func _on_area_entered(hurtbox):
	if not hurtbox is Hurtbox: return
	
	damage = GameStats.calculate_damage()
	hurtbox.take_hit(self, damage)

	if "Player" in hurtbox.get_groups():
		GameStats.reset_multiplier()
