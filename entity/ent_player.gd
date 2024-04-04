@tool
class_name Player
extends CharacterBody3D

var targetname

func _func_godot_apply_properties(properties: Dictionary):
	if 'targetname' in properties:
		targetname = properties.targetname
