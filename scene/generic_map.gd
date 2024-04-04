extends Node3D

@export var music: AudioStream


func _ready():
	if music != null:
		AudioManager.set_music(music)
		AudioServer.set_bus_volume_db(0, 0.5)

