extends Control

var gui

# Called when the node enters the scene tree for the first time.
func _ready():
	gui = get_node("Performosport")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_performosport_pressed():
	Flags.performosport += 1
	GameStateManager.player.update_fov()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gui.hide()
	print("weewa")
	
