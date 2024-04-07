extends Node

const music_volume = -15

func set_music(audio: AudioStream, volume = null, keep_time = false):
	if volume != null:
		$Music.volume_db = int(volume) + music_volume
	if $Music.stream != audio:
		var playback_time = 0
		if keep_time == true:
			playback_time = $Music.get_playback_position()
		$Music.stream = audio
		$Music.play(playback_time)
