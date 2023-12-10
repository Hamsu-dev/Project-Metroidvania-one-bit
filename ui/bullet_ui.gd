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
		call_deferred("_update_label_for_reloading")
	else:
		update_bullet_label(PlayerStats.current_ammo)
		set_label_font_size(6)
		
func _update_label_for_reloading():
	bullet_label.text = "Reloading..."
	set_label_font_size(4)

func set_label_font_size(new_size: int):
	bullet_label.add_theme_font_size_override("font_size", new_size)
