extends Node2D
var confirm = false

func _on_start_pressed():
	var startButton = get_node("Start")
	if(confirm == false):
		startButton.text = "Okay but are you sure tho"
		confirm = true
	else:
		get_tree().change_scene_to_file("res://scene/generic_map.tscn")


func _on_quit_pressed():
	get_tree().quit()
