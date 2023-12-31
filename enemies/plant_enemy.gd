extends Node2D

const EnemyBulletScene = preload("res://enemies/enemy_bullet.tscn")
const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var bullet_speed = 30
@export var spread = 30

@onready var stats = $Stats
@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var fire_direction = $FireDirection

var is_knockback_active = false
var knockback_velocity = Vector2()

signal enemy_died

func fire_bullet():
	var bullet = Utils.instantiate_scene_on_world(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction = global_position.direction_to(fire_direction.global_position)
	var velocity = direction.normalized() * bullet_speed
	velocity = velocity.rotated(randf_range(-deg_to_rad(spread/2), deg_to_rad(spread/2)))
	bullet.velocity = velocity


func _on_hurtbox_hurt(hitbox, damage, direction):
	stats.health -= damage
	apply_knockback(direction)


func apply_knockback(direction):
	is_knockback_active = true
	knockback_velocity = direction * stats.knockback_force


func _on_stats_no_health():
	GameStats.increment_kill_count()
	enemy_died.emit(self)
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, bullet_spawn_point.global_position)
	queue_free()


func get_damage_label_offset() -> Vector2:
	return Vector2(-2 , 10)
