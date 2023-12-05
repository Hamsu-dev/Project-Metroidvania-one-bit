extends ColorRect


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_load_button_pressed():
	print("load save game")


func _on_quit_button_pressed():
	get_tree().quit()
