extends Node

var sound_effects = {
	"gem_match": preload("res://Assets/Sound/ping2.wav"),
}

func play_sound(sound_name: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if sound_name not in sound_effects:
		push_error("Sound not found: " + sound_name)
		return
	
	var player = AudioStreamPlayer.new()
	player.stream = sound_effects[sound_name]
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	add_child(player)
	player.play()
	
	# Clean up after sound finishes
	await player.finished
	player.queue_free()
