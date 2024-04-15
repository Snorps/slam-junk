extends Node3D
class_name DestroyOffMap

@export var destroyee: Node

func _ready():
	if not is_instance_valid(destroyee):
		destroyee = get_node("..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.y < -20:
		GameStateManager.has_destroyed(self)
		on_destroy()
		destroyee.queue_free()

func on_destroy():
	pass
