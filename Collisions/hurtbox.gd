class_name Hurtbox
extends Area2D

var DamageIndicator = preload("res://ui/DamageIndicator.gd")
var is_invincible = false :
	set(value):
		is_invincible = value
		disable.call_deferred(value)

signal hurt(hitbox, damage, direction)


func take_hit(hitbox, damage, direction):
	if is_invincible:
		return
	hurt.emit(hitbox, damage, direction)
	
	if get_parent() and get_parent().is_in_group("Player"):
		return
		
	var offset = Vector2.ZERO
	if get_parent() and get_parent().has_method("get_damage_label_offset"):
		offset = get_parent().get_damage_label_offset()

	# Create and show damage label
	var damage_label = DamageIndicator.new()
	damage_label.initialize_damage_label(damage, global_position + offset, offset) 
	get_tree().current_scene.add_child(damage_label)
	damage_label.start_display()

func disable(value):
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.disabled = value
