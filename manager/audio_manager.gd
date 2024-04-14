extends Node

const music_volume = -15
const fade_rate = 10

var target_volume
var waitingroom
@onready var current_music_player = $Music
@onready var musicBackdrop = $PerformoLayer
@onready var soundEffects = $SoundEffects

enum SoundTag {MUSIC, WORLD, VOICE}

func set_music(audio: AudioStream, volume = null, keep_time = false):
	if volume != null:
		target_volume = int(volume) + music_volume
		current_music_player.volume_db = target_volume
	if current_music_player.stream != audio:
		var playback_time = 0
		if keep_time == true:
			playback_time = current_music_player.get_playback_position()
		current_music_player.stream = audio
		current_music_player.play(playback_time)
		if(waitingroom == null):
			waitingroom = true
		print("1: " + str(waitingroom))
		PerformoAudio(playback_time)
		
func PerformoAudio(playback_time):
	if(Flags.get_upgrade("performosport").equipped > 0):
			if(waitingroom == true):
				musicBackdrop.stop()
				musicBackdrop.stream = load("res://audio/Ball room performosport.wav")
				musicBackdrop.volume_db = target_volume - 5
				musicBackdrop.play(playback_time)
				print(current_music_player.stream)
				waitingroom = false
				print("2: " + str(waitingroom))
			else:
				print("3")
				musicBackdrop.stop()
				musicBackdrop.stream = load("res://audio/Bounsyball performosport.wav")
				musicBackdrop.volume_db = target_volume - 5
				musicBackdrop.play(playback_time)
				print(current_music_player.stream)
				waitingroom = true
				
				
	if(Flags.get_upgrade("performosport").equipped == 0):
		musicBackdrop.stop()
	
func crossfade_music(audio: AudioStream):
	if current_music_player.stream.resource_path.to_lower() == audio.resource_path.to_lower(): return
	var playback_time = current_music_player.get_playback_position()
	if current_music_player == $Music:
		current_music_player = $Music2
	else:
		current_music_player = $Music
	current_music_player.stream = audio
	current_music_player.volume_db = -15
	current_music_player.play(playback_time)
	
func play_sound(audio: AudioStream, player: AudioStreamPlayer = soundEffects, tag: SoundTag = SoundTag.WORLD):
	player.stream = audio
	player.play()
	
func ShopClose():
	soundEffects.stream = load("res://audio/vendclose.wav")
	soundEffects.play()

func PlayVend():
	soundEffects.stream = load("res://audio/vendopen.wav")
	soundEffects.play()
	
func _process(delta):
	if target_volume == null: return
	var off_player
	if current_music_player == $Music:
		off_player = $Music2
	else:
		off_player = $Music
	if off_player.stream == null: return
	if current_music_player.volume_db < target_volume:
		current_music_player.volume_db += fade_rate * delta
	if current_music_player.volume_db > target_volume:
		current_music_player.volume_db = target_volume
	off_player.volume_db -= fade_rate * delta
