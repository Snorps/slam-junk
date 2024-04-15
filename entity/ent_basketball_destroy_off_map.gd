extends DestroyOffMap


# Called when the node enters the scene tree for the first time.
func on_destroy():
	GameStateManager.lose_point()
