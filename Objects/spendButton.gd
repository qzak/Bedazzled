extends Control

@export var spend_gems_type = ""
@export var gem_tooltip_text = ""

signal spend_button_pressed(gem_type: String)

var tooltip_visible = false
var cost_tooltip_text = ""

func _ready() -> void:
	# Connect mouse signals if not already connected in editor
	if not $Button.is_connected("mouse_entered", Callable(self, "_on_button_mouse_entered")):
		$Button.mouse_entered.connect(_on_button_mouse_entered)
	if not $Button.is_connected("mouse_exited", Callable(self, "_on_button_mouse_exited")):
		$Button.mouse_exited.connect(_on_button_mouse_exited)
	cost_tooltip_text = "Cost: " + str(Global.amethyst_ability_cost) + " Amethysts"
	$Button/TooltipContainer/TooltipText.text = str(gem_tooltip_text) + "\n" + str(cost_tooltip_text)


func _process(_delta: float) -> void:
	$Button/Label.text = str(Global.total_gems_matched[spend_gems_type])
	
	# Make tooltip follow mouse when visible
	if tooltip_visible:
		var tooltip_box = $Button/TooltipContainer
		var tooltip_text = $Button/TooltipContainer/TooltipText
		tooltip_box.global_position = get_global_mouse_position() + Vector2(20, 10)
		tooltip_text.global_position = get_global_mouse_position() + Vector2(20, 10)

func _on_spend_button_pressed() -> void:
	spend_button_pressed.emit(spend_gems_type)


func _on_button_mouse_entered() -> void:
	# Show tooltip with gem type and number of gems available to spend
	var tooltip_box = $Button/TooltipContainer
	var tooltip_text = $Button/TooltipContainer/TooltipText
	tooltip_box.show()
	tooltip_text.show()
	tooltip_visible = true


func _on_button_mouse_exited() -> void:
	# Hide tooltip when mouse leaves
	var tooltip_box = $Button/TooltipContainer
	var tooltip_text = $Button/TooltipContainer/TooltipText
	tooltip_box.hide()
	tooltip_text.hide()
	tooltip_visible = false
	
