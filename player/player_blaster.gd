extends Node2D

const BulletScene: PackedScene = preload("res://player/bullet.tscn")
const MissileScene: PackedScene = preload("res://player/missile.tscn")

signal bullets_changed(current_ammo)
signal reloading_status_changed(is_reloading)

# Blaster stats
var fire_rate: float = 0.1 # Time between shots
var reload_speed: float = 2.0 # Time to reload
var ammo_capacity: int = 10

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Node2D = $BlasterSprite/Muzzle

var last_shot_time: int = 0 # Keeps track of the last shot time
var current_ammo: int = ammo_capacity
var is_reloading: bool = false
var missile_active = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reload") and not is_reloading and current_ammo < ammo_capacity:
		start_reloading()
	elif Input.is_action_just_pressed("reload") and current_ammo == ammo_capacity:
		print("Ammo full!")


func start_reloading() -> void:
	print("reloading...")
	is_reloading = true
	reloading_status_changed.emit(is_reloading)
	current_ammo = 0
	await get_tree().create_timer(reload_speed).timeout
	current_ammo = ammo_capacity
	is_reloading = false
	reloading_status_changed.emit(is_reloading)
	bullets_changed.emit(current_ammo)

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()


func fire_bullet():
	if Time.get_ticks_msec() - last_shot_time > fire_rate * 1000 and current_ammo > 0 and not is_reloading:
		var bullet: Node2D = Utils.instantiate_scene_on_world(BulletScene, muzzle.global_position)
		bullet.rotation = blaster_sprite.rotation

		# Find the Hitbox node in the instantiated bullet and set its base damage
		var hitbox = bullet.get_node("Hitbox")  # Replace "Hitbox" with the correct path if necessary
		if hitbox:
			hitbox.base_damage = 2  # Set the base damage for a normal bullet

		bullet.update_velocity()  # Assuming this is a method in the Bullet script
		current_ammo -= 1
		bullets_changed.emit(current_ammo)
	
		if current_ammo <= 0:
			start_reloading()
		last_shot_time = Time.get_ticks_msec()

func fire_missile():
	if missile_active: return
	missile_active = true
	var missile = Utils.instantiate_scene_on_world(MissileScene, muzzle.global_position)
	missile.missile_deactivated.connect(_on_missile_deactivated)
	missile.rotation = blaster_sprite.rotation

	# Set the base damage for the instantiated missile
	var hitbox = missile.get_node("Hitbox")  # Replace "Hitbox" with the correct path if necessary
	if hitbox:
		hitbox.base_damage = 5  # Set the base damage for a missile

	missile.update_velocity()


func _on_missile_deactivated():
	missile_active = false


func _on_bullets_changed(current_ammo):
	pass # Replace with function body.


func _on_reloading_status_changed(is_reloading):
	pass # Replace with function body.
