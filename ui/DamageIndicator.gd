# DamageLabel.gd
extends Label

# Declare member variables to store the damage amount and position
var damage_amount: float
var initial_position: Vector2

# This initialization method sets up the damage label
func initialize_damage_label(damage_amount: float, position: Vector2):
	self.damage_amount = damage_amount  # Store these for later use in start_display
	self.initial_position = position
	text = str(damage_amount)
	global_position = initial_position + Vector2(0, -20)  # Adjusted offset from passed position

# Call this method when the label is ready to be shown
func start_display():
	show()
	# Now we use the stored damage amount and position to animate
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)  # Fade out over 1 second
	tween.tween_property(self, "position", initial_position + Vector2(0, -50), 1)  # Move up
	tween.finished.connect(queue_free)
