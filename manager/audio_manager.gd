extends Node

func set_music(audio: AudioStream, volume = 0.0):
	$Music.volume_db = volume
	if $Music.stream != audio:
		$Music.stream = audio
		$Music.play()
