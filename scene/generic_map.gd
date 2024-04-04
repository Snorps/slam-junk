extends Node3D

@export var music: AudioStream

func _ready():
	if music != null:
		AudioManager.set_music(music)

func _input(event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
