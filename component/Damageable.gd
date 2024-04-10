extends Area3D

@export var health = 100
@export var lose_on_die = false

const damage_frequency = 0.5

var overlaps = []
var damageTimer
var damagePopup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	damagePopup = get_node("DamagePopup")
	damagePopup.hide()
	
	damageTimer = get_node("damageTimer")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for entry in overlaps:
		entry.time -= delta
		if entry.time <= 0:
			entry.time = damage_frequency
			health -= entry.damage
			print(health)
		if health <= 0:
			die()
		


func _on_body_entered(body):
	var damage_source = body.get_node("DamageSource")
	if damage_source == null: return
	var damage = 5
	if "damage" in damage_source:
		damage = damage_source.damage
	overlaps.append({"body"=body, "time"=damage_frequency, "damage"=damage})
	health -= damage
	print(health)
	
	damagePopup.show()
	damageTimer.start()
	
	
	if health <= 0:
		die()


func _on_body_exited(body):
	for entry in overlaps:
		if entry.body == body:
			overlaps.erase(entry)
			
func die():
	if "die" in $"..":
		$"..".die()
	if lose_on_die:
		GameStateManager.lose_game()
	queue_free()


func _on_damage_timer_timeout():
	damagePopup.hide()
