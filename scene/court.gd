extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.set_music(load("res://audio/BOUNSYBALL3.wav"))
