extends Node3D

var zoom_speed = 0.03
var rot_speed = 0.018

func _ready():
	$Camera3D.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera3D.position.y += zoom_speed
	$Camera3D.rotation.y += rot_speed
