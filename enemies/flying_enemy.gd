extends CharacterBody2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var acceleration = 100
@export var max_speed = 40

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var stats = $Stats
@onready var way_point_path_finding = $WayPointPathFinding

var is_knockback_active = false
var knockback_velocity = Vector2()
var knockback_timer = Timer.new()


signal enemy_died

func _ready():
	initialize_enemy()
	add_child(knockback_timer)
	knockback_timer.timeout.connect(_on_knockback_timer_timeout)


func initialize_enemy():
	set_physics_process(false)

func _physics_process(delta):
	if is_knockback_active:
		velocity = knockback_velocity
	else:
		var player = MainInstances.player
		if player is CharacterBody2D:
			move_toward_position(way_point_path_finding.pathfinding_next_position, delta)

	move_and_slide()

func move_toward_position(target_position, delta):
	var direction = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	move_and_slide()

func _on_hurtbox_hurt(hitbox, damage, direction):
	stats.health -= damage
	apply_knockback(direction)


func apply_knockback(direction):
	is_knockback_active = true
	knockback_velocity = direction * stats.knockback_force
	knockback_timer.start(0.2) # Adjust the duration to your preference

func _on_knockback_timer_timeout():
	is_knockback_active = false
	# Reset velocity or any other properties if necessary

func _on_stats_no_health():
	GameStats.increment_kill_count()
	enemy_died.emit(self)
	queue_free()
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position)

func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)

func get_damage_label_offset() -> Vector2:
	return Vector2(-2 , 10)
