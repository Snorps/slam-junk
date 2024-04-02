extends Node

var levels = [
	"level1-pit.map",
	"level1-hoop.map"
]

var lose_nodes = []
var score
var level
var map = levels[0]

func _ready():
	reset_game()
	
func reset_game():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	level = 0
	score = 0
	map = levels[level]

func lose():
	score -= 1
	HUD.get_node("CenterText").text = "FuckYou"
	reset_level()
	
func win():
	score += 1
	level += 1
	HUD.get_node("CenterText").text = "You scored point!"
	reset_level()
	
	
func reset_level():
	HUD.get_node("TopLeftText").text = str(score) + ":0"
	if level >= levels.size():
		reset_game()
		return
	map = levels[level]
	await get_tree().create_timer(1).timeout
	await get_tree().change_scene_to_file("res://generic_map.tscn")

func lose_if_destroyed(obj):
	lose_nodes.append(obj)

func has_destroyed(obj):
	if lose_nodes.has(obj):
		lose()
