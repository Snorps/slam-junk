extends Node

@export var generic_map_scene: PackedScene
@export var game_complete_scene: PackedScene

@export var glitch_end_image: Texture2D
@export var good_end_image: Texture2D
@export var bad_end_image: Texture2D

var levels = [
	{"mapname"="level1-pregame.map", "spawn_point"="player_hallway"},
	{"mapname"="level1-court-hoop.map"},
	{"mapname"="level1-court-hoop.map"},
	{"mapname"="level1-court-hoop.map"}
]

var lose_nodes = []
var score
var level = 0
var map
var player
var builder
var performoLevels
var necroLevels
var game_end_message
var game_end_image
var vending_machine_ui

#var spawn_point_name = null

func _ready():
	reset_game()
	
func lose_point():
	if resetting == true: return
	score -= 1
	HUD.get_node("CenterText").text = "FuckYou"
	$LoseSound.play()
	reset_level()
	
func lose_game():
	$LoseSound.play()
	level = 0
	HUD.set_centre_text("You had became died! :(")
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(generic_map_scene)
	map = {"mapname"="level1-pregame.map", "spawn_point"="player_changing_room"}
	return
	
func reset_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	level = 0
	score = 0
	Flags.reset()

	
func win():
	score += 1
	level += 1
	HUD.set_centre_text("You scored point!")
	$ScoreSound.play()
	reset_level()
	
var resetting = false
func reset_level():
	if resetting == true: return
	resetting = true
	HUD.get_node("TopLeftText").text = str(score) + ":0"
	if level >= levels.size():
		#HUD.set_centre_text("You had became beated the game!")
		game_end("And so, Coach brought Slam Duncan, his best player, out for a big yummy pizza lunch.", good_end_image)
		return
	map = levels[level]
	await get_tree().create_timer(1).timeout
	await get_tree().change_scene_to_packed(generic_map_scene)
	resetting = false
	
func game_end(message, image):
	get_tree().change_scene_to_packed(game_complete_scene)
	reset_game()
	game_end_message = message
	game_end_image = image

func lose_if_destroyed(obj):
	lose_nodes.append(obj)

func has_destroyed(obj):
	if lose_nodes.has(obj):
		lose_point()
