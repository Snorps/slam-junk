extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_performosport_pressed():
	Flags.performosport += 1
	GameStateManager.player.update_fov()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	


func _on_necrogluterol_pressed():
	GameStateManager.player.get_node("Damageable").health = 0
	GameStateManager.lose_game()
