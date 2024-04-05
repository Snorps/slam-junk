extends Node

const music_volume = -15

func set_music(audio: AudioStream, volume = 0.0):
	$Music.volume_db = int(volume) + music_volume
	if $Music.stream != audio:
		$Music.stream = audio
		$Music.play()
