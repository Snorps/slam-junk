extends Node3D

const refresh_rate = 0.3
const turn_speed = 0.045
const run_speed = 0.8

@onready var angle = Vector3.FORWARD.angle_to(transform.basis.z)
@onready var body = $"../Body"

func _physics_process(delta):
	var angle_to = transform.basis.z.signed_angle_to(global_position - GameStateManager.player.position, Vector3.UP)
	var diff = rad_to_deg(abs(angle_to - angle))
	if diff > 170:
		angle = -angle
	if angle_to > angle:
		angle += turn_speed
	else:
		angle -= turn_speed

func get_vector():
	return -transform.basis.y * run_speed
