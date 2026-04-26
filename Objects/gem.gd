extends Node2D

@export var gemType = ""
var defaultScale = 0.2
var matched = false
var is_hovered = false

func _on_area_2d_mouse_entered():
	if !matched && !Global.scoring_in_progress:
		z_index = 100
		var animation = get_tree().create_tween()
		animation.tween_property($AnimatedSprite2D, "scale", Vector2(defaultScale * 1.2, defaultScale * 1.2), 0.1)

func _on_area_2d_mouse_exited():
	if !matched:
		z_index = 0
		var animation = get_tree().create_tween()
		animation.tween_property($AnimatedSprite2D, "scale", Vector2(defaultScale, defaultScale), 0.1)

func match():
	matched = true
	#scale the gem down til it disappears to indicate it's been matched
	var animation = get_tree().create_tween()
	print("Scaling down gem at position: " + str(position))
	animation.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_SINE)
	await animation.finished

func score(gem_score):
	# return gemType and de-instantiate the gem instance
	$ScoreLabel.text = str(gem_score)
	var score_animation = get_tree().create_tween()
	score_animation.set_parallel(true)
	score_animation.tween_property($ScoreLabel, "position:y", $ScoreLabel.position.y - 50, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	score_animation.tween_property($ScoreLabel, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	return gemType
