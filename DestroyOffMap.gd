extends Node3D

@export var destroyee: Node
@export var lose_on_destroy: bool

func _ready():
	if not is_instance_valid(destroyee):
		destroyee = get_node("..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.y < -20:
		GameStateManager.has_destroyed(self)
		if lose_on_destroy == true:
			GameStateManager.lose_game()
		destroyee.queue_free()
