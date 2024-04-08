extends AnimatableBody3D

@export var head: Node3D

const grab_distance = 3
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
		var query = PhysicsRayQueryParameters3D.create(head.global_position, head.global_position+look_vector()*grab_distance)
		#query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		if not result: return
		if "get_hover_message" in result.collider:
			var message = result.collider.get_hover_message()
			if message != null:
				HUD.get_node("CenterText").text = message
		highlighted_object = result.collider
		#print(result.collider.name)
		#print("distance: " + str((result.position - head.global_position).length()))
		if result.collider.name == "GrabHitbox":
			highlighted_object = result.collider.get_node("..")
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
	#PhysicsServer3D.body_set_state(
		#highlighted_object.get_rid(),
		#PhysicsServer3D.BODY_STATE_TRANSFORM,
		#Transform3D.IDENTITY.translated(global_position)
	#)
	if highlighted_object == null: return
	if "player_interact" in highlighted_object:
		highlighted_object.player_interact()
		inputBuffer = false
	if highlighted_object is RigidBody3D:
		grab_object = highlighted_object
	inputBuffer = false

func throw():
	grab_object.apply_impulse(look_vector() * throw_force)
	grab_object = null

func look_vector():
	return (global_position - head.global_position).normalized()
	
