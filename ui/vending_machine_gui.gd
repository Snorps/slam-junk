extends Control


var performoLabel
var necroLabel
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	performoLabel = get_node("PerformoLabel")
	necroLabel = get_node("NecroLabel")
	
func _process(delta):
	pass


func _on_performosport_pressed():
	Flags.add_money(-25)
	if(Flags.performosport < 5):
		Flags.performosport += 1
		print(Flags.performosport)
	GameStateManager.player.update_fov()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	performoLabel.text = "Moneycosts: five fives \nAmountsof: " + str(Flags.performosport) + "\nMAXOPERFORMO: FIVE"
	hide()
	


func _on_necrogluterol_pressed():
	Flags.add_money(-15)
	GameStateManager.player.get_node("Damageable").health = 0
	GameStateManager.lose_game()


func _on_quit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
