extends Node

@export var map: FuncGodotMap = null
@export var voxel_gi: VoxelGI = null

var players = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameStateManager.builder = self
	if map == null:
		print("Builder node has no func_godot Map reference set.")
		return
	build()
	
func register_player_spawn(player, targetname):
	players.append({"name"=targetname, "player" = player})
	
func build():
	EntityTargetManager.emitters = []
	if GameStateManager.map != null:
		map.global_map_file = "res://maps/" + GameStateManager.map.mapname
	await map.verify_and_build()
	await map.unwrap_uv2()
	
func try_pick_spawn():
	if players.size() > 1:
		if "spawn_point" in GameStateManager:
			for player_entry in players:
				if player_entry.name != GameStateManager.spawn_point_name:
					player_entry.player.queue_free()
	
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
