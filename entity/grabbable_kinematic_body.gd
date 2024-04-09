extends AnimatableBody3D
class_name GrabbableBody3D

var mass = 1
var bounciness = 0.98
var gravity_mult = 0.01

@onready var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var gravity = base_gravity * gravity_mult

var linear_velocity = Vector3.ZERO

func _physics_process(delta):
	if linear_velocity == null: return
	linear_velocity.y -= gravity * delta
	var collision = move_and_collide(linear_velocity * delta)
	if not collision: return
	on_bounce()
	linear_velocity = linear_velocity.bounce(collision.get_normal()) * bounciness
	
func apply_impulse(force: Vector3):
	linear_velocity += force
	
func on_bounce():
	pass
	
