extends AnimatableBody3D
class_name GrabbableBody3D

var mass = 1
var bounciness = 0.98
var gravity_mult = 0.01

@onready var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gravity = base_gravity * gravity_mult

var linear_velocity = Vector3.ZERO

func _physics_process(delta):
	update_trajectory(delta)
	
func update_trajectory(delta):
	if linear_velocity == null: return
	linear_velocity.y -= gravity * delta
	var collision = move_and_collide(linear_velocity * delta)
	if not collision: return
	on_bounce()
	if "on_collide" in collision.get_collider():
		collision.get_collider().on_collide(self)
		
	#bounciness calculation (prevents ball going crazy)
	var normal = collision.get_normal()
	#abs it so that ceilings are 0 angle from horizon
	normal = Vector3(abs(normal.x),abs(normal.y),abs(normal.z))
	var angle_from_horizon = Vector3.UP.angle_to(normal)
	angle_from_horizon = rad_to_deg(angle_from_horizon)
	angle_from_horizon *= 0.03
	angle_from_horizon = clamp(angle_from_horizon, 1, 90)
	var bounciness_this_frame = bounciness * (1/angle_from_horizon)
	
	linear_velocity = linear_velocity.bounce(collision.get_normal()) * bounciness_this_frame
	
func apply_impulse(force: Vector3):
	linear_velocity += force
	
func on_bounce():
	pass
	
