extends CharacterBody3D

var playerPos
var angleToPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GameStateManager.player != null):
		playerPos = GameStateManager.player.position
		
		look_at(playerPos)
		##rotation.y = rad_to_deg(get_tree().get_root().get_node("World/FuncGodotMap/entity_2_ent_player").position.x * delta * -1)
