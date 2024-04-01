extends Area3D

signal trigger()

var is_pressed = false
var base_translation = Vector3.ZERO
var axis := Vector3.DOWN
var speed := 8.0
var depth := 0.8
var release_delay := 0.0
var trigger_signal_delay :=  0.0
var press_signal_delay :=  0.0
var release_signal_delay :=  0.0

var overlaps := 0

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)
	connect("body_shape_exited", body_shape_exited)

func _enter_tree() -> void:
	base_translation = position

func _process(delta: float) -> void:
	var target_position = base_translation + (axis * (depth if is_pressed else 0.0))
	position = position.lerp(target_position, speed * delta)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return

	if overlaps == 0:
		press()

	overlaps += 1

func body_shape_exited(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return

	overlaps -= 1

func press() -> void:
	if is_pressed:
		return

	is_pressed = true

	emit_trigger()

func emit_trigger() -> void:
	await get_tree().create_timer(trigger_signal_delay).timeout
	GameStateManager.win()
	#trigger.emit()

func _func_godot_apply_properties(props: Dictionary):
	if "target" in props:
		EntityTargetManager.register_emitter(self, props.target)
		
	if 'axis' in props:
		axis = props.axis.normalized()

	if 'speed' in props:
		speed = props.speed

	if 'depth' in props:
		depth = float(props.depth)

	if 'trigger_signal_delay' in props:
		trigger_signal_delay = props.trigger_signal_delay
