extends Control

@onready var master_volume: HSlider = %MasterVolume
@onready var sound_effects_volume: HSlider = %SoundEffectsVolume
@onready var master_value: Label = %MasterValue
@onready var sound_effects_value: Label = %SoundEffectsValue

func _ready() -> void:
	master_volume.value = AudioManager.get_master_volume() * 100.0
	sound_effects_volume.value = AudioManager.get_sound_effects_volume() * 100.0
	update_volume_labels()
	%StartButton.grab_focus()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Screens/gameScreen.tscn")

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
