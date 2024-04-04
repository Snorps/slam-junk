extends Control

var paused = false
var resumeButton
var quitButton
#var resumeButton = get_tree().get_root().get_node("Resume")
#var quitButton = get_tree().get_root().get_node("Quit")

func _ready():
	resumeButton = get_node("Resume")
	quitButton = get_node("Quit")
	resumeButton.hide()
	quitButton.hide()
	

func _input(event):
	if(Input.is_key_pressed(KEY_ESCAPE)):
		if(paused == false):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			resumeButton.show()
			quitButton.show()
			get_tree().paused = true
			paused = true
			
			


func _on_quit_button_down():
	get_tree().quit()


func _on_resume_button_down():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	resumeButton.hide()
	quitButton.hide()
	get_tree().paused = false
	paused = false
