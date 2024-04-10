extends Node3D

@export var head: Node3D
@export var audio_player: AudioStreamPlayer3D

const grab_distance = 50
const grab_force = 800
const grab_speed_damping = 0.93
const throw_force = 10
const grab_grace_period = 0.5
const preview_rate = 0.005

var grab_object = null
var highlighted_object = null
var time_left_to_grab = 0
var inputBuffer = false
var preview_models = []
var preview_delay_remaining = 0

var hasGrabSoundPlayed = false

func _physics_process(delta):
	time_left_to_grab -= delta
	if grab_object != null:
		grab_object.apply_impulse((global_position - grab_object.global_position) * grab_object.mass * grab_force * delta)
		grab_object.linear_velocity *= grab_speed_damping
		generate_throw_preview(delta)
	else:
		for c in preview_models:
			if is_instance_valid(c):
				c.queue_free()
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(head.global_position, head.global_position+look_vector()*grab_distance)
		#query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		HUD.set_hands_text("")
		if not result: return
		if "get_hover_message" in result.collider:
			var message = result.collider.get_hover_message()
			if message != null:
				HUD.set_hands_text(message)
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

func generate_throw_preview(delta):
	if not grab_object is GrabbableBody3D: return
	preview_delay_remaining -= delta
	if preview_delay_remaining > 0: return
	for c in preview_models:
		if is_instance_valid(c):
			c.queue_free()
	preview_delay_remaining = preview_rate
	var throw_preview = grab_object.duplicate()
	throw_preview.set_collision_layer_value(1, false)
	throw_preview.set_collision_mask_value(1, false)
	throw_preview.set_collision_layer_value(2, true)
	throw_preview.set_collision_mask_value(2, true)
	throw_preview.global_position = grab_object.global_position
	get_tree().current_scene.add_child(throw_preview)
	throw_preview.apply_impulse(look_vector() * throw_force)
	var model = Node3D.new()
	for c in throw_preview.get_children():
		if c is MeshInstance3D:
			model.add_child(c.duplicate())
	for i in 15:
		throw_preview.update_trajectory(0.1)
		var new_model = model.duplicate()
		new_model.global_position = throw_preview.global_position
		get_tree().current_scene.add_child(new_model)
		preview_models.append(new_model)
		print(throw_preview.global_position)
	throw_preview.queue_free()
	

func try_grabthrow():
	if grab_object != null:
		throw()
		return
	
	if(grab_object == null):
		inputBuffer = true
		time_left_to_grab = grab_grace_period
	else:
		inputBuffer = false
		time_left_to_grab = 0
	

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
	if highlighted_object is RigidBody3D or highlighted_object is GrabbableBody3D:
		grab_object = highlighted_object
		
		if(hasGrabSoundPlayed == false):
			print("gfdjkgkfg")
			audio_player.stream = load("res://audio/grab.wav")
			audio_player.play()
			hasGrabSoundPlayed = true
			
	
	

func throw():
	grab_object.apply_impulse(look_vector() * throw_force)
	grab_object = null
	audio_player.stream = load("res://audio/THROW.wav")
	audio_player.play()
	hasGrabSoundPlayed = false

func look_vector():
	return (global_position - head.global_position).normalized()
	
