extends Node

enum Build_Stage {PRE_POPULATE, POPULATE}
var build_stage = Build_Stage.PRE_POPULATE

var connected = false

var emitters = []

func register_emitter(node, value):
	emitters.append({"node" = node, "value" = value})
	
func get_emitters():
	return emitters
