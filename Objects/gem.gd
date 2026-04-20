extends Node2D

@export var gemType = ""

var defaultScale = 0.2
var matched = false
var is_hovered = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_mouse_entered():
	if !matched:
		var animation = get_tree().create_tween()
		animation.tween_property($AnimatedSprite2D, "scale", Vector2(defaultScale * 1.2, defaultScale * 1.2), 0.1)

func _on_area_2d_mouse_exited():
	if !matched:
		var animation = get_tree().create_tween()
		animation.tween_property($AnimatedSprite2D, "scale", Vector2(defaultScale, defaultScale), 0.1)

func match():
	matched = true
	#scale the gem down til it disappears to indicate it's been matched
	var animation = get_tree().create_tween()
	print("Scaling down gem at position: " + str(position))
	animation.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_SINE)
	await animation.finished

func score():
	# return gemType and de-instantiate the gem instance
	queue_free()
	return gemType
