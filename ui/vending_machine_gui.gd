extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_performosport_button_down():
	Flags.performosport += 1
	GameStateManager.player.update_fov()
	print("weewa")
