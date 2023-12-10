extends HBoxContainer

@onready var bullet_label = $Label

func _ready():
	update_bullet_label(PlayerStats.current_ammo)  # Initial update
	PlayerStats.bullets_changed.connect(_on_bullets_changed)
	PlayerStats.reloading_status_changed.connect(_on_reloading_status_changed)

func update_bullet_label(bullet_count: int):
	bullet_label.text = str(bullet_count)

func _on_bullets_changed(current_ammo: int):
	bullet_label.text = str(current_ammo)

func _on_reloading_status_changed(is_reloading: bool):
	if is_reloading:
		bullet_label.text = ("Reloading...")
	else:
		update_bullet_label(PlayerStats.current_ammo)
