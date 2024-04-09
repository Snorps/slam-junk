extends CharacterBody3D

var gui
var guiButton

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D

var speed := 1.0

func _ready():
	gui = get_tree().get_root().get_node("World/VendingMachineGui")

var _hover_message = "Use vending machine."
func player_interact():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	gui.UpdateText()
	gui.show()
	
	
func get_hover_message():
	if _hover_message != null:
		return _hover_message
	return null
