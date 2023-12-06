extends Node2D

const EnemyBulletScene = preload("res://enemies/enemy_bullet.tscn")
const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var bullet_speed = 30
@export var spread = 30

@onready var stats = $Stats
@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var fire_direction = $FireDirection

signal enemy_died

func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction = global_position.direction_to(fire_direction.global_position)
	var velocity = direction.normalized() * bullet_speed
	velocity = velocity.rotated(randf_range(-deg_to_rad(spread/2), deg_to_rad(spread/2)))
	bullet.velocity = velocity


func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage


func _on_stats_no_health():
	GameStats.increment_kill_count()
	enemy_died.emit(self)
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, bullet_spawn_point.global_position)
	queue_free()


#func _on_stats_health_changed(amount_changed):
#	if amount_changed < 0:
#			var damage_number = preload("res://ui/DamageIndicator.tscn").instantiate()
#			damage_number.text = str(abs(amount_changed))
#			add_child(damage_number)
#			damage_number.global_position = global_position + Vector2(-2.5, -25)
