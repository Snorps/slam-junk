extends CharacterBody3D

@onready var gui = load("res://ui/vending_machine_gui.tscn").instantiate()

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D

var speed := 1.0

func _ready():
	add_child(gui)
	gui.visible = false

var _hover_message = "Use vending machine."
func player_interact():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	gui.visible = true
	get_tree().current_scene.add_child(gui)
	
func get_hover_message():
	if _hover_message != null:
		return _hover_message
	return null
