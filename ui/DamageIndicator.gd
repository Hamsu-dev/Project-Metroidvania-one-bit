extends Label

var damage_amount: float
var initial_position: Vector2
var offset: Vector2  # Additional parameter for offset

func initialize_damage_label(damage_amount: float, position: Vector2, offset: Vector2):
	self.damage_amount = damage_amount
	self.initial_position = position
	self.offset = offset  # Store the offset
	text = str(damage_amount)
	# Apply the offset to the initial position
	var random_offset = Vector2(randf_range(-10, 10), randf_range(-30, -20))
	global_position = initial_position + offset + random_offset  # Adjusted offset from passed position

func start_display():
	show()
	# Now we use the stored damage amount, position, and offset to animate
	var tween = create_tween()
	var fade_out_duration = randf_range(0.8, 1.2)  # Randomized fade out duration
	tween.tween_property(self, "modulate:a", 0, fade_out_duration)  # Fade out

	# Adjust end position with the offset
	var random_x_movement = randf_range(-15, 15)
	var end_position = initial_position + offset + Vector2(random_x_movement, -50)  # Randomized movement
	tween.tween_property(self, "position", end_position, fade_out_duration)  # Move up
	tween.finished.connect(queue_free)
