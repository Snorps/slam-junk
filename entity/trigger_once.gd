extends Area3D

signal trigger()

var is_pressed = false
var trigger_signal_delay :=  0.0

var overlaps := 0

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)
	connect("body_shape_exited", body_shape_exited)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if not (body == GameStateManager.player):
		return

	if overlaps == 0:
		press()

	overlaps += 1

func body_shape_exited(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if not (body == GameStateManager.player):
		return

	overlaps -= 1

func press() -> void:
	if is_pressed:
		return

	is_pressed = true

	emit_trigger()

func emit_trigger() -> void:
	await get_tree().create_timer(trigger_signal_delay).timeout
	trigger.emit()

func _func_godot_apply_properties(props: Dictionary):
	if "target" in props:
		EntityTargetManager.register_emitter(self, props.target)
	if 'trigger_signal_delay' in props:
		trigger_signal_delay = props.trigger_signal_delay
