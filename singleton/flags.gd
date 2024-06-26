extends Node

var _money = 0

var upgrades = [
	{
		"name" = "performosport",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 2,
		"price" = 25
	},
	{
		"name" = "necrogluterol",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 3,
		"price" = 12
	},
	{
		"name" = "sportimax",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 1,
		"price" = 25
	},
		{
		"name" = "omniscerine",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 2,
		"price" = 25
	},
	{
		"name" = "skidaddlide",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 5,
		"price" = 16
	},
	{
		"name" = "bicepscene",
		"equipped" = 0,
		"unlocked" = 0,
		"max" = 4,
		"price" = 19
	}
]

func _ready():
	reset()

func reset():
	add_money(0)
	
func get_upgrade(name):
	for upgrade in upgrades:
		if upgrade.name == name:
			return upgrade
	return null

func refresh_upgrades_effects():
	GameStateManager.vending_machine_ui.update()
	GameStateManager.player.update_fov()
	#apply effects
	AudioManager.PerformoAudio()
	var player = GameStateManager.player
	if player != null:
		var skidaddlide = get_upgrade("skidaddlide").equipped
		player.ACCELERATION_DEFAULT = 7 + (1.5*skidaddlide)
		player.SPEED_DEFAULT = 7 + (1.5*skidaddlide)
		player.SPEED_ON_STAIRS = 5 + (1.5*skidaddlide)
		
		var omniscerine = get_upgrade("omniscerine").equipped
		var hands = player.get_node("Body/Head/Hands")
		hands.preview_distance = 7 * omniscerine
		
		var necrogluterol = get_upgrade("necrogluterol").equipped
		var sportimax = get_upgrade("sportimax").equipped
		if necrogluterol > 0 or sportimax > 0:
			player.get_node("Damageable").on_die()
			get_upgrade("necrogluterol").equipped = 0
			get_upgrade("sportimax").equipped = 0
			
		var bicepscene = get_upgrade("bicepscene").equipped
		hands.grab_force = 800 + (120000 * bicepscene)
		hands.grab_speed_damping = 0.93 - (0.04 * bicepscene)

	AudioManager.PerformoAudio()
	
func purge_upgrades():
	for upgrade in upgrades:
		upgrade.equipped = 0
	refresh_upgrades_effects()
	
func get_money():
	return _money
	
func add_money(value):
	_money += value
	HUD.get_node("TopRightText").text = str(_money) + "b"
