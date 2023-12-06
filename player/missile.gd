extends Projectile

const BigExplosionEffectScene = preload("res://effects/big_explosion_effect.tscn")

signal missile_deactivated

var lifetime = 5.0
var homing_strength = 0.09
var homing_active = true

func _ready():
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _process(delta):
	if homing_active:
		var mouse_position = get_global_mouse_position()
		var direction_to_mouse = (mouse_position - global_position).normalized()
		velocity = velocity.lerp(direction_to_mouse * speed, homing_strength)
		velocity = velocity.normalized() * speed

		rotation = velocity.angle()  # Set the missile's rotation to match its velocity
		position += velocity * delta

func _on_timer_timeout():
	homing_active = false
	emit_signal("missile_deactivated")
	Utils.instantiate_scene_on_world(BigExplosionEffectScene, global_position)
	queue_free()

func _on_hitbox_body_entered(body):
	Utils.instantiate_scene_on_world(BigExplosionEffectScene, global_position)
	queue_free()

func _on_hitbox_area_entered(area):
	Utils.instantiate_scene_on_world(BigExplosionEffectScene, global_position)    
	queue_free()

func _exit_tree():
	emit_signal("missile_deactivated")
