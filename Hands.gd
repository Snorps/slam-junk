extends AnimatableBody3D

@export var head: Node3D

const grab_force = 10000
const grab_speed_damping = 0.96
const throw_force = 1.5
const grab_grace_period = 0.5

var grab_object = null
var highlighted_object = null
var time_left_to_grab = 0
var inputBuffer = false

func _physics_process(delta):
	time_left_to_grab -= delta
	if grab_object != null:
		grab_object.apply_force((global_position - grab_object.global_position) * grab_object.mass * grab_force * delta)
		grab_object.linear_velocity *= grab_speed_damping
	else:
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(head.global_position, look_vector()*50)
		var result = space_state.intersect_ray(query)
		if not result: return
		if not result.collider is RigidBody3D: return
		highlighted_object = result.collider
		time_left_to_grab = grab_grace_period
	if(inputBuffer):
		grab()
		time_left_to_grab -= delta
		if(time_left_to_grab <= 0):
			inputBuffer = false

func try_grabthrow():
	if grab_object != null:
		throw()
		return
	
	inputBuffer = true
	time_left_to_grab = grab_grace_period	
	

func grab():
	if time_left_to_grab <= 0: return
	PhysicsServer3D.body_set_state(
		highlighted_object.get_rid(),
		PhysicsServer3D.BODY_STATE_TRANSFORM,
		Transform3D.IDENTITY.translated(global_position)
	)
	grab_object = highlighted_object
	if(grab_object != null):
		inputBuffer = false

func throw():
	grab_object.apply_impulse(look_vector() * throw_force)
	grab_object = null

func look_vector():
	return (global_position - head.global_position).normalized()
	
