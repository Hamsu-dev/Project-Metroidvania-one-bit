extends CharacterBody2D


const EnemyDeathEffectScene = preload("res://effects/enemy_death_effect.tscn")

@export var speed = 30.0
@export var turns_at_ledges = true

var gravity = 200.0
var direction = 1.0

@onready var death_effect_location = $DeathEffectLocation
@onready var sprite_2d = $Sprite2D
@onready var floor_cast = $FloorCast
@onready var stats = $Stats

signal enemy_died

func _ready():
	initialize_enemy()

func initialize_enemy():
	var player = MainInstances.player
	if player:
		var player_position = player.global_position
		direction = sign(global_position.direction_to(player_position).x)
		sprite_2d.scale.x = direction

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall():
		turn_around()
	
	if is_at_ledge() and turns_at_ledges:
		turn_around()

	velocity.x = direction * speed
	sprite_2d.scale.x = direction
	
	move_and_slide()

func is_at_ledge():
	return is_on_floor() and not floor_cast.is_colliding()

func turn_around():
	direction *= -1.0

func _on_hurtbox_hurt(hitbox, damage):
	stats.health -= damage


func _on_stats_no_health():
	GameStats.increment_kill_count()
	enemy_died.emit(self)
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, death_effect_location.global_position)
	queue_free()


#func _on_stats_health_changed(amount_changed):
#	if amount_changed < 0:
#			var damage_number = preload("res://ui/DamageIndicator.tscn").instantiate()
#			damage_number.text = str(abs(amount_changed))
#			add_child(damage_number)
#			damage_number.global_position = global_position + Vector2(-2.5, -25)
