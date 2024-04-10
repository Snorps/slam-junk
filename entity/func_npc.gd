extends CharacterBody3D

var playerPos
var npcPos
var angleToPlayer
var initRotation

func _ready():
	initRotation = rotation
	npcPos = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(GameStateManager.player != null):
		playerPos = GameStateManager.player.position
		
		look_at(playerPos)
		
		if (npcPos.distance_to(playerPos) < 5):
			print("Test")
			look_at(playerPos)
			rotation.x = initRotation.x
			rotation.x = initRotation.z
		else:
			rotation = initRotation
