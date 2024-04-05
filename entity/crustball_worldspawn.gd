extends StaticBody3D

func _func_godot_apply_properties(props: Dictionary):
	if "music" in props:
		var music = load(props.music)
		if is_instance_valid(music):
			AudioManager.set_music(music)
