extends MeshInstance3D

var speed = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_surface_override_material(0).uv1_offset.x += delta * speed
	if(get_surface_override_material(0).uv1_offset.x >= 1):
		get_surface_override_material(0).uv1_offset.x = 0
