extends Control

@export var title_screen: PackedScene

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GameStateManager.game_end_message != null:
		$Description.text = GameStateManager.game_end_message
	if GameStateManager.game_end_image != null:
		$Image.texture = GameStateManager.game_end_image

func _on_button_pressed():
	get_tree().change_scene_to_packed(title_screen)
