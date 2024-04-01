@tool
class_name PhysicsBall
extends PhysicsEntity

func _func_godot_apply_properties(properties: Dictionary):
	if 'size' in properties:
		$MeshInstance.mesh.radius = properties.size * 0.5
		$MeshInstance.mesh.height = properties.size

		$CollisionShape.shape.radius = properties.size * 0.5
	if 'mass' in properties:
		mass = properties.mass


func use():
	bounce()

func bounce():
	linear_velocity.y = 10
