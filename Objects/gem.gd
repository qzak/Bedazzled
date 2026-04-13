extends Node2D

@export var gemType = ""

var defaultScale = 0.2


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


#func _on_area_2d_mouse_entered():
#	var tween = create_tween()
#	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0.3, 0.3), 0.3)
#
#func _on_area_2d_mouse_exited() -> void:
#	var tween = create_tween()
#	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0.2, 0.2), 0.3)
