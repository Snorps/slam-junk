extends Node3D

@export var music: AudioStream


func _ready():
	if music != null:
		AudioManager.set_music(music)

