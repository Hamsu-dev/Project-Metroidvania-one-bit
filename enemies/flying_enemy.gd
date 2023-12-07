extends CharacterBody2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var acceleration = 100
@export var max_speed = 40

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var stats = $Stats
@onready var way_point_path_finding = $WayPointPathFinding

signal enemy_died

func _ready():
	initialize_enemy()

func initialize_enemy():
	set_physics_process(false)

func _physics_process(delta):
	var player = MainInstances.player
	if player is CharacterBody2D:
		move_toward_position(way_point_path_finding.pathfinding_next_position, delta)

func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	move_and_slide()

func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage

func _on_stats_no_health():
	GameStats.increment_kill_count()
	enemy_died.emit(self)
	queue_free()
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)

func get_damage_label_offset() -> Vector2:
	return Vector2(-2 , 10)
