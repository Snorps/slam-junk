extends HBoxContainer

var upgrade
var lights = []

@export var light_equipped: Texture2D
@export var light_not_equipped: Texture2D
@export var light_not_bought: Texture2D

func _ready():
	for i in upgrade.max:
		var light = TextureRect.new()
		light.texture = light_not_bought
		add_child(light)
		lights.append(light)
		light.scale.y = 0.5
		light.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	$Button.text = "Buy " + upgrade.name + ": " + str(upgrade.price) + "b"

func _on_button_pressed():
	print("pressed " + upgrade.name + " button")
	if upgrade.equipped < upgrade.unlocked:
		upgrade.equipped += 1
	elif upgrade.unlocked < upgrade.max:
		if Flags.get_money() < upgrade.price: return
		Flags.add_money(-upgrade.price)
		upgrade.unlocked += 1
		upgrade.equipped += 1
	update()
	Flags.refresh_upgrades_effects()

func update():
	#update lights
	var i = 1
	for light in lights:
		light.texture = light_not_bought
		if upgrade.equipped >= i:
			light.texture = light_equipped
		elif upgrade.unlocked >= i:
			light.texture = light_not_equipped
		i += 1
