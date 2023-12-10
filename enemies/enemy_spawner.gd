extends Area2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")
const BigExplosionEffectScene = preload("res://effects/big_explosion_effect.tscn")


@export var enemy_scene: PackedScene
@export var base_max_active_enemies = 3
@export var spawn_rate = 1.0  # Time between each enemy spawn
@export var spawn_cooldown = 5.0  # Cooldown time before spawning the next batch

var active_enemies = []
var spawner_difficulty_multiplier = 1
var max_active_enemies
var initial_spawn_done = false
var is_dead = false 
var is_knockback_active = false
var knockback_velocity = Vector2()
var knockback_timer = Timer.new()

@onready var death_effect_location = $DeathEffectLocation
@onready var stats = $Stats
@onready var spawn_timer = Timer.new()
@onready var cooldown_timer = Timer.new()
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Hurtbox/CollisionShape2D
@onready var hurtbox = $Hurtbox


func _ready():
	set_process(false)
	setup_timers()
	add_child(spawn_timer)
	add_child(cooldown_timer)

func setup_timers():
	spawn_timer.wait_time = spawn_rate
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	cooldown_timer.wait_time = spawn_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cool_down_timer_timeout)

func _on_body_entered(body: Node):
	if is_dead: return
	if !initial_spawn_done and body.is_in_group("Player"):
		initial_spawn_done = true
		adjust_difficulty(DifficultyManager.difficulty_level)
		start_spawning_sequence()

func adjust_difficulty(difficulty_level):
	spawner_difficulty_multiplier = max(difficulty_level, 1)  # Ensure it's at least 1
	max_active_enemies = base_max_active_enemies * spawner_difficulty_multiplier

func _on_spawn_timer_timeout():
	if is_dead: return
	if active_enemies.size() < max_active_enemies:
		_spawn_enemy()
		set_variable_spawn_rate()
		spawn_timer.start()  # Schedule next spawn

func start_spawning_sequence():
	if is_dead: return
	if active_enemies.size() < max_active_enemies:
		_spawn_enemy()  # Spawn first enemy immediately
		set_variable_spawn_rate()  # Set a variable spawn rate
		spawn_timer.start()  # Schedule next spawn
	else:
		cooldown_timer.start()  # Start cooldown before next batch


func set_variable_spawn_rate():
	var variance = randf_range(-0.2, 0.2)  # Adjust variance as needed
	spawn_timer.wait_time = spawn_rate + variance


func _spawn_enemy():
	play_spawn_effect() 
	call_deferred("_deferred_spawn_enemy")


func play_spawn_effect():
	animated_sprite_2d.play("Spawn")
	

func _deferred_spawn_enemy():
	if enemy_scene:
		var enemy = Utils.instantiate_scene_on_world(enemy_scene, global_position)
		enemy.initialize_enemy()
		active_enemies.append(enemy)
		enemy.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(dead_enemy):
	active_enemies.erase(dead_enemy)
	if active_enemies.size() < max_active_enemies and not spawn_timer.is_stopped():
		spawn_timer.start()
	elif active_enemies.size() == 0:
		cooldown_timer.start()  # Start cooldown if all enemies are cleared

func _on_hurtbox_hurt(hitbox, damage, direction):
	stats.health -= damage
	apply_knockback(direction)

func apply_knockback(direction):
	pass

func _on_stats_no_health():
	if is_dead: return
	is_dead = true
	Events.add_screenshake.emit(5, 0.2)
	animated_sprite_2d.play("Dead")
	call_deferred("_finalize_death")


func _finalize_death():
	collision_shape_2d.disabled = true
	hurtbox.monitoring = false
	spawn_timer.stop()
	cooldown_timer.stop()


func _on_cool_down_timer_timeout():
	start_spawning_sequence()


func get_damage_label_offset() -> Vector2:
	return Vector2(0 , -5)
