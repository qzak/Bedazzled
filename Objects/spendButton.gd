extends Control

@export var spend_gems_type = ""

signal spend_button_pressed(gem_type: String)

func _process(delta: float) -> void:
	$Button/Label.text = str(Global.total_gems_matched[spend_gems_type])

func _on_spend_button_pressed() -> void:
	spend_button_pressed.emit(spend_gems_type)
