extends Area3D

var overlaps := 0

var is_pressed = false

var music

func _init() -> void:
	connect("body_shape_entered", body_shape_entered)
	connect("body_shape_exited", body_shape_exited)

func body_shape_entered(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if not (body == GameStateManager.player):
		return

	##checks that the entity triggering the goal post is, in fact, baketbol
	if overlaps == 0:
		press()

	overlaps += 1

func body_shape_exited(body_id, body: Node, body_shape_idx: int, self_shape_idx: int) -> void:
	if not (body == GameStateManager.player):
		return

	overlaps -= 1

func press() -> void:
	if music != null:
		AudioManager.crossfade_music(music)


func _func_godot_apply_properties(props: Dictionary):
	if 'music' in props:
		music = load(props.music)
