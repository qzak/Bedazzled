class_name ScoreRoller
extends Control

const DISPLAY_DIGITS := 8
const MAX_DISPLAY_SCORE := 99_999_999

@export var digit_font: Font
@export var digit_font_size := 130
@export var digit_color := Color(1, 0.83, 0.35, 1)

var current_score_text := ""
var rollers: Array = []
var roller_box: HBoxContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	roller_box = HBoxContainer.new()
	roller_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	roller_box.alignment = BoxContainer.ALIGNMENT_CENTER
	roller_box.add_theme_constant_override("separation", 4)
	add_child(roller_box)
	set_score(0, false)

func set_score(new_score: int, animate := true) -> void:
	var new_score_text := str(mini(new_score, MAX_DISPLAY_SCORE)).pad_zeros(DISPLAY_DIGITS)
	if new_score_text == current_score_text:
		return
	ensure_roller_count(new_score_text.length())
	for digit_index in new_score_text.length():
		rollers[digit_index].set_digit(new_score_text[digit_index], animate and not current_score_text.is_empty())
	current_score_text = new_score_text

func set_digit_font_size(new_size: int) -> void:
	if digit_font_size == new_size:
		return
	digit_font_size = new_size
	for roller in rollers:
		roller.apply_style(digit_font, digit_font_size, digit_color)

func ensure_roller_count(required_count: int) -> void:
	while rollers.size() < required_count:
		var roller := DigitRoller.new()
		roller.apply_style(digit_font, digit_font_size, digit_color)
		rollers.append(roller)
		roller_box.add_child(roller)

class DigitRoller extends Panel:
	const ADJACENT_DIGIT_PEEK_RATIO := 0.34

	var above_label := Label.new()
	var current_label := Label.new()
	var below_label := Label.new()
	var displayed_digit := ""
	var roll_tween: Tween
	var roll_queue: Array = []

	func _ready() -> void:
		clip_contents = true
		add_child(above_label)
		add_child(current_label)
		add_child(below_label)
		resized.connect(update_label_sizes)
		call_deferred("update_label_sizes")

	func apply_style(font: Font, font_size: int, color: Color) -> void:
		custom_minimum_size = Vector2(roundi(font_size * 0.65), font_size * 1.1)
		size_flags_vertical = Control.SIZE_FILL
		var reel_style := StyleBoxFlat.new()
		reel_style.bg_color = Color(0.96, 0.96, 0.92, 1)
		reel_style.border_width_left = 2
		reel_style.border_width_top = 2
		reel_style.border_width_right = 2
		reel_style.border_width_bottom = 2
		reel_style.border_color = Color(0.08, 0.1, 0.13, 1)
		reel_style.corner_radius_top_left = 6
		reel_style.corner_radius_top_right = 6
		reel_style.corner_radius_bottom_right = 6
		reel_style.corner_radius_bottom_left = 6
		reel_style.shadow_color = Color(0, 0, 0, 0.35)
		reel_style.shadow_size = 3
		add_theme_stylebox_override("panel", reel_style)
		for digit_label in [above_label, current_label, below_label]:
			digit_label.add_theme_font_override("font", font)
			digit_label.add_theme_font_size_override("font_size", font_size)
			digit_label.add_theme_color_override("font_color", color)
			digit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			digit_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		update_label_sizes()

	func set_digit(new_digit: String, animate: bool) -> void:
		if displayed_digit == new_digit:
			return
		if displayed_digit.is_empty() or not animate:
			displayed_digit = new_digit
			roll_queue.clear()
			set_static_strip()
			return

		if roll_tween:
			roll_tween.kill()
		set_static_strip()
		roll_queue.clear()
		var rolling_digit := displayed_digit.to_int()
		while rolling_digit != new_digit.to_int():
			rolling_digit = (rolling_digit + 1) % 10
			roll_queue.append(str(rolling_digit))
		start_next_roll()

	func start_next_roll() -> void:
		if roll_queue.is_empty():
			return
		var next_digit: String = roll_queue.pop_front()
		var roller_height := size.y if size.y > 0.0 else custom_minimum_size.y
		var peek_height := roller_height * ADJACENT_DIGIT_PEEK_RATIO
		below_label.text = next_digit
		above_label.position = Vector2(0, -roller_height + peek_height)
		current_label.position = Vector2.ZERO
		below_label.position = Vector2(0, roller_height - peek_height)
		roll_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		roll_tween.set_parallel(true)
		roll_tween.tween_property(above_label, "position:y", -2.0 * roller_height + 2.0 * peek_height, 0.14)
		roll_tween.tween_property(current_label, "position:y", -roller_height + peek_height, 0.14)
		roll_tween.tween_property(below_label, "position:y", 0.0, 0.14)
		roll_tween.chain().tween_callback(finish_roll.bind(next_digit))

	func finish_roll(next_digit: String) -> void:
		displayed_digit = next_digit
		var recycled_label := above_label
		above_label = current_label
		current_label = below_label
		below_label = recycled_label
		set_static_strip()
		roll_tween = null
		start_next_roll()

	func set_static_strip() -> void:
		if displayed_digit.is_empty():
			return
		var roller_height := size.y if size.y > 0.0 else custom_minimum_size.y
		var peek_height := roller_height * ADJACENT_DIGIT_PEEK_RATIO
		above_label.text = previous_digit(displayed_digit)
		current_label.text = displayed_digit
		below_label.text = next_digit(displayed_digit)
		above_label.position = Vector2(0, -roller_height + peek_height)
		current_label.position = Vector2.ZERO
		below_label.position = Vector2(0, roller_height - peek_height)

	func previous_digit(digit: String) -> String:
		return str((digit.to_int() + 9) % 10)

	func next_digit(digit: String) -> String:
		return str((digit.to_int() + 1) % 10)

	func update_label_sizes() -> void:
		for digit_label in [above_label, current_label, below_label]:
			digit_label.size = size
		if not roll_tween:
			set_static_strip()
