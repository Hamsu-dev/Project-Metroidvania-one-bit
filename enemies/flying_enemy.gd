extends CharacterBody2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var stats = $Stats as Stats

@export var acceleration = 100
@export var max_speed = 40


func _physics_process(delta):
	var player = MainInstances.player
	if player is CharacterBody2D:
		move_toward_position(player.global_position, delta)


func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	move_and_slide()


func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position)
	queue_free()
