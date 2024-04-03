extends Node

@export var generic_map_scene: PackedScene
@export var game_complete_scene: PackedScene

var levels = [
	"level1-pregame.map",
	"level1-court-hoop.map",
	"level1-court-hoop.map",
	"level1-court-hoop.map",
]

var lose_nodes = []
var score
var level
var map

func _ready():
	reset_game()
	
func reset_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	level = 0
	score = 0


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
		get_tree().change_scene_to_packed(game_complete_scene)
		reset_game()
		HUD.get_node("CenterText").text = "You had became beated the game!"
		return
	map = levels[level]
	await get_tree().create_timer(1).timeout
	await get_tree().change_scene_to_packed(generic_map_scene)

func lose_if_destroyed(obj):
	lose_nodes.append(obj)

func has_destroyed(obj):
	if lose_nodes.has(obj):
		lose()
