extends Control

var paused = false
var resumeButton
var quitButton
var volumeLabel
var volumeControl

@export
var audioBusName : String
var audioBusIndex : int

func _ready():
	resumeButton = get_node("Resume")
	quitButton = get_node("Quit")
	volumeControl = get_node("VolumeControl")
	volumeLabel = get_node("VolumeLabel")
	resumeButton.hide()
	volumeControl.hide()
	volumeLabel.hide()
	quitButton.hide()
	
	audioBusIndex = AudioServer.get_bus_index("Master")
	

func _input(event):
	if(Input.is_action_pressed("Pause")):
		
		if(paused == true):
			ResumeGame()
			
		if(paused == false):
			PauseGame()
			
func ResumeGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	resumeButton.hide()
	quitButton.hide()
	volumeControl.hide()
	volumeLabel.hide()
	get_tree().paused = false
	paused = false
	
func PauseGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resumeButton.show()
	volumeControl.show()
	volumeLabel.show()
	quitButton.show()
	get_tree().paused = true
	paused = true

func _on_quit_button_down():
	get_tree().quit()


func _on_resume_button_down():
	ResumeGame()


func _on_settings_button_down():
	resumeButton.hide()
	quitButton.hide()

func _on_volume_control_value_changed(value):
	AudioServer.set_bus_volume_db(audioBusIndex, linear_to_db((value)))
