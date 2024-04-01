extends Node

@export var map: FuncGodotMap = null
@export var voxel_gi: VoxelGI = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if map == null:
		print("Builder node has no func_godot Map reference set.")
		return
	await map.verify_and_build()
	await map.unwrap_uv2()
	
var baked = false
var lights = []
func bake(entity):
	lights.append(entity)
	if baked: return
	baked = true
	if voxel_gi == null:
		print("Builder node has no VoxelGi reference set.")
		return
	voxel_gi.call_deferred("bake")
	
func postbake():
	for light in lights:
		#light.queue_free()
		pass
