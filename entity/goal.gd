extends Area3D

signal trigger()

var is_pressed = false
var trigger_signal_delay :=  0.0

var overlaps := 0

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)
	connect("body_shape_exited", body_shape_exited)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if body is StaticBody3D:
		return

	##checks that the entity triggering the goal post is, in fact, baketbol
	if overlaps == 0:
		if(body.name == "entity_4_physics_ball"):
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
	if 'trigger_signal_delay' in props:
		trigger_signal_delay = props.trigger_signal_delay
