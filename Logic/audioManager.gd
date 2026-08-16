extends Node

const SETTINGS_PATH := "user://audio_settings.cfg"
const MASTER_BUS := "Master"
const SOUND_EFFECTS_BUS := "SoundEffects"

var sound_effects = {
	"gem_match": preload("res://Assets/Sound/ping2.wav"),
}

func _ready() -> void:
	load_settings()

func set_master_volume(value: float) -> void:
	set_bus_volume(MASTER_BUS, value)
	save_settings()

func get_master_volume() -> float:
	return get_bus_volume(MASTER_BUS)

func set_sound_effects_volume(value: float) -> void:
	set_bus_volume(SOUND_EFFECTS_BUS, value)
	save_settings()

func get_sound_effects_volume() -> float:
	return get_bus_volume(SOUND_EFFECTS_BUS)

func set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value, 0.001)))

func get_bus_volume(bus_name: String) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return 1.0
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func save_settings() -> void:
	var settings := ConfigFile.new()
	settings.set_value("audio", "master_volume", get_master_volume())
	settings.set_value("audio", "sound_effects_volume", get_sound_effects_volume())
	settings.save(SETTINGS_PATH)

func load_settings() -> void:
	var settings := ConfigFile.new()
	if settings.load(SETTINGS_PATH) != OK:
		return
	set_bus_volume(MASTER_BUS, settings.get_value("audio", "master_volume", 1.0))
	set_bus_volume(SOUND_EFFECTS_BUS, settings.get_value("audio", "sound_effects_volume", 1.0))

func play_sound(sound_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if sound_name not in sound_effects:
		push_error("Sound not found: " + sound_name)
		return
	
	var player = AudioStreamPlayer.new()
	player.stream = sound_effects[sound_name]
	player.bus = SOUND_EFFECTS_BUS
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	
	# Clean up after sound finishes
	await player.finished
	player.queue_free()
