extends Label

var fade_duration = 1.0
var move_speed = Vector2(0, -50)

func _ready():
	var tween = create_tween()

	var fade_tweener = tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	fade_tweener.set_trans(Tween.TransitionType.TRANS_LINEAR)
	fade_tweener.set_ease(Tween.EaseType.EASE_IN_OUT)

	# Tween for moving up
	var move_tweener = tween.tween_property(self, "position", position + move_speed, fade_duration)
	move_tweener.set_trans(Tween.TransitionType.TRANS_LINEAR)
	move_tweener.set_ease(Tween.EaseType.EASE_IN_OUT)

	tween.finished.connect(_on_tween_all_completed)

func _on_tween_all_completed():
	queue_free()
