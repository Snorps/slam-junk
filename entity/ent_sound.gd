@tool
class_name SoundEntity
extends QodotEntity

var targetname = null
var audio_player_node: AudioStreamPlayer3D = null

func _func_godot_apply_properties(properties: Dictionary):
	audio_player_node = AudioStreamPlayer3D.new()
	if 'sound' in properties:
		audio_player_node.stream = load(properties.sound)
	if 'targetname' in properties:
		targetname = properties.targetname
	if 'volume' in properties:
		audio_player_node.volume_db = float(properties.volume)
		
	add_child(audio_player_node)

func _func_godot_build_complete():
	if targetname:
		var emitters = EntityTargetManager.get_emitters()
		for emitter in emitters:
			if emitter.value == targetname:
				emitter.node.trigger.connect(audio_player_node.play)
