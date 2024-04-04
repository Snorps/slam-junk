extends CharacterBody3D

var base_transform: Transform3D
var offset_transform: Transform3D
var target_transform: Transform3D

var speed := 1.0

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
	
var targetname = null
func _func_godot_apply_properties(props: Dictionary):
	if "targetname" in props:
		targetname = props.targetname
		
	if 'on_touch' in props:
		on_touch = props.on_touch
		
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
				emitter.node.pressed.connect(use)
