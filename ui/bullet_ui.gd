extends HBoxContainer

@onready var bullet_label = $Label
var is_flashing = false
var flash_timer = Timer.new()  # Create a new Timer instance

func _ready():
	update_bullet_label(PlayerStats.current_ammo)  # Initial update
	PlayerStats.bullets_changed.connect(_on_bullets_changed)
	PlayerStats.reloading_status_changed.connect(_on_reloading_status_changed)
	add_child(flash_timer)  # Add the Timer to the scene tree
	flash_timer.wait_time = 0.2  # Decrease the duration of each flash for faster flashes
	flash_timer.timeout.connect(_on_flash_timer_timeout)

func update_bullet_label(bullet_count: int):
	bullet_label.text = str(bullet_count)
	if not is_flashing:
		bullet_label.modulate = Color(1, 1, 1)  # Ensure label is white when not flashing

func _on_bullets_changed(current_ammo: int):
	bullet_label.text = str(current_ammo)

func _on_reloading_status_changed(is_reloading: bool):
	if is_reloading:
		start_flashing_effect()
	else:
		stop_flashing_effect()
		update_bullet_label(PlayerStats.current_ammo)

func start_flashing_effect():
	is_flashing = true
	flash_timer.start()  # Start the flashing timer

func stop_flashing_effect():
	is_flashing = false
	flash_timer.stop()  # Stop the flashing timer
	bullet_label.modulate = Color(1, 1, 1)  # Reset to white

func _on_flash_timer_timeout():
	if is_flashing:
		# Toggle color between black and white
		if bullet_label.modulate == Color(0, 0, 0):
			bullet_label.modulate = Color(1, 1, 1)  # Set to white
		else:
			bullet_label.modulate = Color(0, 0, 0)  # Set to black
	else:
		flash_timer.stop()  # Ensure the timer is stopped if not flashing
