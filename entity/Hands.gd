extends AnimatableBody3D

@export var head: Node3D

@onready var joint = $PinJoint3D

func try_grabthrow():
	if not is_instance_valid(joint): return
	if joint.node_b == null:
		throw()
	else:
		grab()

func grab():
	print(joint.global_position)
	print(global_position)
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var dir = (global_position - head.global_position).normalized()
	var query = PhysicsRayQueryParameters3D.create(head.global_position, dir*50)
	var result = space_state.intersect_ray(query)
	if not result: return
	if not result.collider is RigidBody3D: return
	PhysicsServer3D.body_set_state(
		result.rid,
		PhysicsServer3D.BODY_STATE_TRANSFORM,
		Transform3D.IDENTITY.translated(global_position)
	)
	#joint = PinJoint3D.new()
	#add_child(joint)
	#joint.node_a = self.get_path()
	joint.node_b = result.collider.get_path()

func throw():
	joint.node_b == null
