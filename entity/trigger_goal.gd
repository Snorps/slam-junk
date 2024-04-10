extends Area3D

signal trigger()

var trigger_signal_delay :=  0.5

func _process(delta):
	#for b in get_overlapping_bodies():
	#	on_collide(b)
	pass

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	on_collide(body)
	
func on_collide(body):
	if not body is GrabbableBody3D: return

	##checks that the entity triggering the goal post is, in fact, baketbol
	if(body.linear_velocity.y < 0):
		press()
		

func press() -> void:
	emit_trigger()

func emit_trigger() -> void:
	await get_tree().create_timer(trigger_signal_delay).timeout
	GameStateManager.win()
	trigger.emit()

func _func_godot_apply_properties(props: Dictionary):
	if 'trigger_signal_delay' in props:
		trigger_signal_delay = props.trigger_signal_delay
	if "target" in props:
		EntityTargetManager.register_emitter(self, props.target)
