extends AnimatableBody3D

@export var head: Node3D

var grab_object = null
var grab_force = 10000
var grab_speed_damping = 0.96
var throw_force = 1.5

func _physics_process(delta):
	if grab_object != null:
		grab_object.apply_force((global_position - grab_object.global_position) * grab_object.mass * grab_force * delta)
		grab_object.linear_velocity *= grab_speed_damping

func try_grabthrow():
	if grab_object != null:
		throw()
	else:
		grab()

func grab():
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(head.global_position, look_vector()*50)
	var result = space_state.intersect_ray(query)
	if not result: return
	if not result.collider is RigidBody3D: return
	
	PhysicsServer3D.body_set_state(
		result.rid,
		PhysicsServer3D.BODY_STATE_TRANSFORM,
		Transform3D.IDENTITY.translated(global_position)
	)
	grab_object = result.collider

func throw():
	grab_object.apply_impulse(look_vector() * throw_force)
	grab_object = null

func look_vector():
	return (global_position - head.global_position).normalized()
	
