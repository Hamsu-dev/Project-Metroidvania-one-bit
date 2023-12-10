extends Node2D

const BulletScene: PackedScene = preload("res://player/bullet.tscn")
const MissileScene: PackedScene = preload("res://player/missile.tscn")

@onready var blaster_sprite: Sprite2D = $BlasterSprite
@onready var muzzle: Node2D = $BlasterSprite/Muzzle

var last_shot_time: int = 0 # Keeps track of the last shot time
var is_reloading: bool = false
var missile_active = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("reload") and not is_reloading and PlayerStats.current_ammo < PlayerStats.ammo_capacity:
		start_reloading()
	elif Input.is_action_just_pressed("reload") and PlayerStats.current_ammo == PlayerStats.ammo_capacity:
		print("Ammo full!")


func start_reloading() -> void:
	print("reloading...")
	PlayerStats.set_reloading_status(true)
	PlayerStats.change_ammo(0)
	await get_tree().create_timer(PlayerStats.reload_speed).timeout
	PlayerStats.change_ammo(PlayerStats.ammo_capacity)
	PlayerStats.set_reloading_status(false)


func refill_ammo():
	PlayerStats.change_ammo(PlayerStats.ammo_capacity)
	if is_reloading:
		PlayerStats.set_reloading_status(false)

func is_ammo_full() -> bool:
	return PlayerStats.current_ammo == PlayerStats.ammo_capacity

func _process(delta: float) -> void:
	blaster_sprite.rotation = get_local_mouse_position().angle()


func fire_bullet():
	if Time.get_ticks_msec() - last_shot_time > PlayerStats.fire_rate * 1000 and PlayerStats.current_ammo > 0 and not is_reloading:
		var bullet: Node2D = Utils.instantiate_scene_on_world(BulletScene, muzzle.global_position)
		bullet.rotation = blaster_sprite.rotation

		# Find the Hitbox node in the instantiated bullet and set its base damage
		var hitbox = bullet.get_node("Hitbox")  # Replace "Hitbox" with the correct path if necessary
		if hitbox:
			hitbox.base_damage = 2  # Set the base damage for a normal bullet

		bullet.update_velocity()  # Assuming this is a method in the Bullet script
		PlayerStats.current_ammo -= 1
		PlayerStats.change_ammo(PlayerStats.current_ammo - 1)
		
		if PlayerStats.current_ammo <= 0:
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
