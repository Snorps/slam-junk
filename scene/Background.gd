extends MeshInstance3D

var speed_x = 1
var speed_y = 0.6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_surface_override_material(0).uv1_offset.x += delta * speed_x
	if(get_surface_override_material(0).uv1_offset.x >= 1):
		get_surface_override_material(0).uv1_offset.x = 0
	get_surface_override_material(0).uv1_offset.y += delta * speed_y
	if(get_surface_override_material(0).uv1_offset.y >= 1):
		get_surface_override_material(0).uv1_offset.y = 0
