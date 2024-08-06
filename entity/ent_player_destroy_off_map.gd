extends DestroyOffMap


# Called when the node enters the scene tree for the first time.
func on_destroy():
	get_tree().change_scene_to_file("res://scene/ending.tscn")
