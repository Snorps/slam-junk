extends HBoxContainer

var upgrade
var lights = []

@export var light_equipped: Texture2D
@export var light_not_equipped: Texture2D
@export var light_not_bought: Texture2D

@export var fail_sound: AudioStream
@export var buy_sound: AudioStream
@export var dispense_sound: AudioStream

func _ready():
	for i in upgrade.max:
		var light = TextureRect.new()
		light.texture = light_not_bought
		add_child(light)
		lights.append(light)
		light.scale.y = 0.5
		light.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL

func _on_button_pressed():
	if upgrade.equipped < upgrade.unlocked:
		upgrade.equipped += 1
		AudioManager.play_sound(dispense_sound)
	elif upgrade.unlocked < upgrade.max:
		if Flags.get_money() < upgrade.price: 
			AudioManager.play_sound(fail_sound)
			return
		Flags.add_money(-upgrade.price)
		upgrade.unlocked += 1
		upgrade.equipped += 1
		AudioManager.play_sound(dispense_sound)
		#TODO: Allow both these sounds to play at once
		#AudioManager.play_sound(buy_sound)
	update()
	Flags.refresh_upgrades_effects()

func update():
	#update text
	$Button.disabled = false
	if upgrade.unlocked > upgrade.equipped:
		$Button.text = upgrade.name + ": FREE"
	elif Flags.get_money() >= upgrade.price:
		$Button.text = upgrade.name + ": Buy " + str(upgrade.price) + "b"
	else:
		$Button.text = upgrade.name + ": Can't Afford."
		$Button.disabled = true
	#update lights
	var i = 1
	for light in lights:
		light.texture = light_not_bought
		if upgrade.equipped >= i:
			light.texture = light_equipped
		elif upgrade.unlocked >= i:
			light.texture = light_not_equipped
		i += 1
