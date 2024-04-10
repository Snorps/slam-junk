extends Damageable

var pain_sounds = [
	load("res://audio/pain1.wav"),
	load("res://audio/pain2.wav"),
	load("res://audio/pain3.wav"),
]

func _ready():
	$DamagePopup.hide()

func on_die():
	$"..".die()
	GameStateManager.lose_game()

var rng = RandomNumberGenerator.new()
func on_hurt():
	$"../AudioPlayer".stream = pain_sounds[rng.randi_range(0, pain_sounds.size() - 1)]
	$"../AudioPlayer".play()
	$"../AudioPlayer".stream = load("res://audio/stab.wav")
	$"../AudioPlayer".play()
	$DamagePopup.show()
	await get_tree().create_timer(0.5).timeout
	$DamagePopup.hide()
