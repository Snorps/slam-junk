extends GrabbableBody3D

var rng = RandomNumberGenerator.new()

var bounce_sounds = [
	load("res://audio/bounce1.wav"),
	load("res://audio/bounce2.wav"),
	load("res://audio/bounce3.wav"),
]

func on_bounce():
	$AudioStreamPlayer3D.stream = bounce_sounds[rng.randi_range(0, bounce_sounds.size() - 1)]
	$AudioStreamPlayer3D.play()

func _func_godot_apply_properties(properties: Dictionary):
	if 'size' in properties:
		$MeshInstance.mesh.radius = properties.size * 0.5
		$MeshInstance.mesh.height = properties.size

		$CollisionShape.shape.radius = properties.size * 0.5
	if 'mass' in properties:
		mass = properties.mass
		
