extends Area3D
class_name Damageable

@export var health = 100
@export var lose_on_die = false

const damage_frequency = 0.5

var overlaps = []
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for entry in overlaps:
		entry.time -= delta
		if entry.time <= 0:
			entry.time = damage_frequency
			health -= entry.damage
			on_hurt()
		if health <= 0:
			on_die()
			if lose_on_die:
				GameStateManager.lose_point()
			queue_free()
		


func _on_body_entered(body):
	var damage_source = body.get_node("DamageSource")
	if damage_source == null: return
	var damage = 5
	if "damage" in damage_source:
		damage = damage_source.damage
	overlaps.append({"body"=body, "time"=damage_frequency, "damage"=damage})
	health -= damage
	on_hurt()
	print(health)
	
	
	if health <= 0:
		on_die()
		if lose_on_die:
			GameStateManager.lose_point()
		queue_free()

func on_hurt():
	pass

func on_die():
	pass

func _on_body_exited(body):
	for entry in overlaps:
		if entry.body == body:
			overlaps.erase(entry)
