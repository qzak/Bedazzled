extends Node2D

@export var gemType = ""

var defaultScale = 0.2
var matched = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var dist = global_position.distance_to(mouse_pos)
	if dist <= 100:
		var scale = 0.2 + ((100 - dist) / 1000)
		if defaultScale < scale:
			$AnimatedSprite2D.scale = Vector2(scale, scale)
	else:
		$AnimatedSprite2D.scale = Vector2(defaultScale, defaultScale)

func match():
	matched = true
	#make gem semi-transparent to indicate it has been matched
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.5)