extends Area2D

const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var enemy_scene: PackedScene
@export var max_active_enemies = 3
@export var spawn_rate = 2.0

var active_enemies = []
var time_since_last_spawn = 0.0

@onready var death_effect_location = $DeathEffectLocation
@onready var stats = $Stats

func _ready():
	set_process(false) # Disable processing until activated.


func start_spawning():
	set_process(true) # Start processing to handle spawning.

func _process(delta: float):
	if stats.health <= 0:
		return 
	
	time_since_last_spawn += delta

	if time_since_last_spawn >= spawn_rate and active_enemies.size() < max_active_enemies:
		time_since_last_spawn = 0
		_spawn_enemy()

func _spawn_enemy():
	if enemy_scene:
		var enemy = Utils.instantiate_scene_on_world(enemy_scene, global_position + Vector2(0, -10))  # Adjust the position as needed
		active_enemies.append(enemy)
		print("Spawned enemy, active count: ", active_enemies.size())

func _on_enemy_no_health(_dead_enemy):
	active_enemies.erase(_dead_enemy)
	print("Enemy killed, active count: ", active_enemies.size())

func _on_body_entered(body: Node):
	start_spawning()


func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage


func _on_stats_no_health():
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, death_effect_location.global_position)
	queue_free()
