class_name Hitbox
extends Area2D

@export var damage = 1


func _on_area_entered(hurtbox):
	if not hurtbox is Hurtbox: return
	hurtbox.take_hit(self, damage)

func add_damage(additional_damage: int) -> void:
	damage += additional_damage

func remove_damage(damage_to_remove: int) -> void:
	damage -= damage_to_remove
