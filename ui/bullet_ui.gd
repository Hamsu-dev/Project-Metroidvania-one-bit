extends HBoxContainer

@onready var bullet_label = $Label

func _ready():
	var player_blaster = find_player_blaster()
	if player_blaster:
		update_bullet_label(player_blaster.current_ammo)  # Initial update
		player_blaster.bullets_changed.connect(_on_bullets_changed)
		player_blaster.reloading_status_changed.connect(_on_reloading_status_changed)

func update_bullet_label(bullet_count: int):
	bullet_label.text = str(bullet_count)

func find_player_blaster() -> Node:
	var player_blasters = get_tree().get_nodes_in_group("PlayerBlaster")
	if player_blasters.size() > 0:
		return player_blasters[0]
	else:
		print("PlayerBlaster node not found in group 'PlayerBlaster'")
		return null

func _on_bullets_changed(current_ammo: int):
	bullet_label.text = str(current_ammo)

func _on_reloading_status_changed(is_reloading: bool):
	# Update the UI to reflect reloading status
	if is_reloading:
		bullet_label.text = ("Reloading...")
	else:
		bullet_label.modulate = Color(1, 1, 1)  # Normal color
