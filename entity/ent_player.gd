@tool
class_name Player
extends CharacterBody3D

@export var properties: Dictionary :
	get:
		return properties
	set(new_properties):
		if(properties != new_properties):
			properties = new_properties
			update_properties()


func update_properties():
	if 'size' in properties:
		pass
