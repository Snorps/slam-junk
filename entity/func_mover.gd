extends CharacterBody3D

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D

var speed := 1.0
var on_interact = false

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)

func _process(delta: float) -> void:
	transform = transform.interpolate_with(target_transform, speed * delta)

func _ready() -> void:
	base_transform = transform
	target_transform = base_transform

func use() -> void:
	play_motion()

func play_motion() -> void:
	target_transform = base_transform * offset_transform

func reverse_motion() -> void:
	target_transform = base_transform
	
var on_touch = false
func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if on_touch == false: return
	use()
	
var _hover_message = "Open door."
func player_interact():
	if not on_interact: return
	use()
	
func get_hover_message():
	if on_interact and _hover_message != null:
		return _hover_message
	return null
	
var targetname = null
func _func_godot_apply_properties(props: Dictionary):
	if "targetname" in props:
		targetname = props.targetname
		
	if 'on_touch' in props:
		on_touch = props.on_touch
		
	if 'on_interact' in props:
		on_interact = props.on_interact
		
	if "hover_message" in props:
		_hover_message = props.hover_message
		
	if 'translation' in props:
		offset_transform.origin = props.translation

	if 'rotation' in props:
		offset_transform.basis = offset_transform.basis.rotated(Vector3.RIGHT, props.rotation.x)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.UP, props.rotation.y)
		offset_transform.basis = offset_transform.basis.rotated(Vector3.FORWARD, props.rotation.z)

	if 'scale' in props:
		offset_transform.basis = offset_transform.basis.scaled(props.scale)

	if 'speed' in props:
		speed = props.speed
		
func _func_godot_build_complete():
	if targetname:
		var emitters = EntityTargetManager.get_emitters()
		for emitter in emitters:
			if emitter.value == targetname:
				emitter.node.trigger.connect(use)
