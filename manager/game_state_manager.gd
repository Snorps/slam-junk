extends Node

var lose_nodes = []
var score = 0

func lose():
	score -= 1
	HUD.get_node("CenterText").text = "FuckYou"
	reset_level()
	
func win():
	score += 1
	HUD.get_node("CenterText").text = "You scored point!"
	reset_level()
	
func reset_level():
	HUD.get_node("TopLeftText").text = str(score) + ":0"
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://generic_map.tscn")

func lose_if_destroyed(obj):
	lose_nodes.append(obj)

func has_destroyed(obj):
	if lose_nodes.has(obj):
		lose()
