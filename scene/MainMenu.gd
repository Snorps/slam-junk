extends Node2D
var confirm = false

const ball_speed = 2
const ball_aggression = 1.5
const ball_glitch_chance = 0.08

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
var time = 0
@onready var title_base_scale = $Title.scale
func _process(delta):
	time += delta
	var bounce = sin(time*50)/50
	$Title.scale = title_base_scale + Vector2(bounce, bounce)
	var rot = ball_speed * delta
	if rng.randf_range(0.0, 1.0) > 1-ball_glitch_chance:
		var rand = rng.randf_range(0, 10.0)
		var sign = rng.randi_range(0,1) * 2 - 1
		rot += sign * (-log(-rand + 10) * ball_aggression + ball_aggression)
	$Node3D/TheBall.rotation.y += rot

func _on_quit_pressed():
	get_tree().quit()
