extends Control

@export var title_screen: PackedScene

func _on_button_pressed():
	get_tree().change_scene_to_packed(title_screen)
	$Description.text = GameStateManager.game_end_message
