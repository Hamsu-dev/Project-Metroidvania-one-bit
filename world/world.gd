extends Node2D

@onready var level = $Level1

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_levels)
	
func clear_bullets():
	var bullets = get_tree().get_nodes_in_group("EnemyBullets")
	for bullet in bullets:
		bullet.queue_free()


func change_levels(door : Door):
	var player = MainInstances.player as Player
	if not player is Player: return
	
	clear_bullets()
	
	level.queue_free()
	var new_level = load(door.new_level_path).instantiate()
	add_child(new_level)
	level = new_level
	
	var doors = get_tree().get_nodes_in_group("doors")
	for found_door in doors:
		if found_door.connection == door.connection and found_door != door:
			var yoffset = player.global_position.y - door.global_position.y
			player.global_position = found_door.global_position + Vector2(0, yoffset)
			break
