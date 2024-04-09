extends Node3D

var playerPos
var angleToPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_tree().get_root().get_node("World/FuncGodotMap/entity_2_ent_player") != null):
		playerPos = get_tree().get_root().get_node("World/FuncGodotMap/entity_2_ent_player").position
		
		look_at(playerPos)
		##rotation.y = rad_to_deg(get_tree().get_root().get_node("World/FuncGodotMap/entity_2_ent_player").position.x * delta * -1)
