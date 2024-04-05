extends Node2D
var confirm = false

const ball_speed = 2

@export var music: AudioStream

func _ready():
	if music != null:
		AudioManager.set_music(music)

func _on_start_pressed():
	GameStateManager.map = GameStateManager.levels[0]
	var startButton = get_node("Start")
	if(confirm == false):
		startButton.text = "Okay but are you sure tho"
		confirm = true
	else:
		get_tree().change_scene_to_file("res://scene/generic_map.tscn")

var rng = RandomNumberGenerator.new()
func _process(delta):
	var rot = ball_speed * delta
	if rng.randf_range(0.0, 10.0) > 9.5:
		var rand = rng.randf_range(0, 10.0)
		var sign = rng.randi_range(0,1) * 2 - 1
		rot += sign * (-log(-rand + 10) * 2 + 2)
	$Node3D/TheBall.rotation.y += rot

func _on_quit_pressed():
	get_tree().quit()
