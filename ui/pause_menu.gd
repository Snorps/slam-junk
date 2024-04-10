extends Control

var paused = false
var resumeButton
var quitButton
var volumeLabel
var volumeControl
var performoLabel
var upgradeLabel
var necroLabel
var moneyLabel
var fullscreenButton

@export
var audioBusName : String
var audioBusIndex : int

func _ready():
	resumeButton = get_node("Resume")
	quitButton = get_node("Quit")
	volumeControl = get_node("VolumeControl")
	volumeLabel = get_node("VolumeLabel")
	performoLabel = get_node("PerformosportLabel")
	upgradeLabel = get_node("UpgradeLabel")
	necroLabel = get_node("NecroLabel")
	moneyLabel = get_node("MoneyLabel")
	fullscreenButton = get_node("Fullscreen")
	fullscreenButton.hide()
	moneyLabel.hide()
	performoLabel.hide()
	upgradeLabel.hide()
	necroLabel.hide()
	resumeButton.hide()
	volumeControl.hide()
	volumeLabel.hide()
	quitButton.hide()
	
	audioBusIndex = AudioServer.get_bus_index("Master")
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		fullscreenButton.text = "Screen ensmallen :("
	else:
		fullscreenButton.text = "Screen ENHAMCE"
	

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
	performoLabel.hide()
	necroLabel.hide()
	upgradeLabel.hide()
	moneyLabel.hide()
	fullscreenButton.hide()
	get_tree().paused = false
	paused = false
	
func PauseGame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resumeButton.show()
	volumeControl.show()
	volumeLabel.show()
	quitButton.show()
	performoLabel.show()
	necroLabel.show()
	upgradeLabel.show()
	moneyLabel.show()
	fullscreenButton.show()
	get_tree().paused = true
	var shopMenu = get_tree().get_root().get_node("World/VendingMachineGui")
	moneyLabel.text = "Dollareydoos: " + str(Flags._money)
	performoLabel.text = "Performosports: " + str(Flags.performosport)
	shopMenu.hide()
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


func _on_fullscreen_button_down():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreenButton.text = "Screen ENHAMCE"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		fullscreenButton.text = "Screen ensmallen :("
