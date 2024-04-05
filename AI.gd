extends Node3D

const refresh_rate = 0.3
const turn_speed = 0.5

@onready var angle = Vector3.FORWARD.angle_to(transform.basis.z)

func _physics_process(delta):
	if transform.basis.z.angle_to(GameStateManager.player.position) > 0:
		angle += turn_speed
	else:
		angle -= turn_speed

func get_vector():
	#if GameStateManager.player == null:
	#	return Vector3.ZERO
	#return (position - GameStateManager.player.position).normalized()
	return Vector3.FORWARD
