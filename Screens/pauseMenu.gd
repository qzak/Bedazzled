extends CanvasLayer

signal resume_requested

@onready var master_volume: HSlider = %MasterVolume
@onready var sound_effects_volume: HSlider = %SoundEffectsVolume
@onready var master_value: Label = %MasterValue
@onready var sound_effects_value: Label = %SoundEffectsValue
@onready var overlay: Control = $Overlay

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	master_volume.value = AudioManager.get_master_volume() * 100.0
	sound_effects_volume.value = AudioManager.get_sound_effects_volume() * 100.0
	update_volume_labels()
	hide_menu()

func show_menu() -> void:
	overlay.show()
	%ResumeButton.grab_focus()

func hide_menu() -> void:
	overlay.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		resume_requested.emit()
		get_viewport().set_input_as_handled()

func _on_resume_button_pressed() -> void:
	resume_requested.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_master_volume_value_changed(value: float) -> void:
	AudioManager.set_master_volume(value / 100.0)
	update_volume_labels()

func _on_sound_effects_volume_value_changed(value: float) -> void:
	AudioManager.set_sound_effects_volume(value / 100.0)
	update_volume_labels()

func update_volume_labels() -> void:
	master_value.text = "%d%%" % roundi(master_volume.value)
	sound_effects_value.text = "%d%%" % roundi(sound_effects_volume.value)
