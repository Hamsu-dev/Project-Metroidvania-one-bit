extends Node2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export var crawling_direction = DIRECTION.RIGHT
@export var max_speed = 150
@export var spin_speed = 600

@onready var floor_cast = $FloorCast
@onready var wall_cast = $WallCast
@onready var stats = $Stats as Stats
@onready var animated_sprite_2d = $AnimatedSprite2D

var gravity = 100
var is_knockback_active = false
var knockback_velocity = Vector2()
var knockback_timer = Timer.new()
var state = crawling_state

signal enemy_died

func _ready():
	initialize_enemy()
	add_child(knockback_timer)
	knockback_timer.timeout.connect(_on_knockback_timer_timeout)

func initialize_enemy():
	# Crawling enemy specific initialization
	var player = MainInstances.player
	if player:
		# Set the crawling direction based on player position, if needed
		crawling_direction = sign(global_position.direction_to(player.global_position).x)
	wall_cast.target_position.x *= crawling_direction

func _physics_process(delta):
	state.call(delta)
	
	
func crawling_state(delta):
	animated_sprite_2d.play("crawl")
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		var while_limit = 30
		while not floor_cast.is_colliding():
			rotation_degrees += crawling_direction
			floor_cast.force_raycast_update()
			while_limit -= 1
			if while_limit <= 0:
				state = falling_state
				break
			
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()

func falling_state(delta):
	animated_sprite_2d.play("fall")
	rotation_degrees += crawling_direction * spin_speed * delta
	position.y += gravity * delta

	if floor_cast.is_colliding() or wall_cast.is_colliding():
		state = crawling_state


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

func get_damage_label_offset() -> Vector2:
	return Vector2(0 , 5)
