class_name Hurtbox
extends Area2D

var DamageIndicator = preload("res://ui/DamageIndicator.gd")
var is_invincible = false :
	set(value):
		is_invincible = value
		disable.call_deferred(value)

signal hurt(hitbox, damage)


func take_hit(hitbox, damage):
	if is_invincible:
		return
	emit_signal("hurt", hitbox, damage)

	# Create and show damage label right when hurt
	var damage_label = DamageIndicator.new()
	damage_label.initialize_damage_label(damage, global_position) 
	get_tree().current_scene.add_child(damage_label)
	damage_label.start_display()

func disable(value):
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.disabled = value


