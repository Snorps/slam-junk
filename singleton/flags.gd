extends Node

var _money

var performosport
var totalPerformo
var maxPerformo

var necrogluterol_unlocked
var necroMax

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
		"price" = 15
	}
]

func _ready():
	reset()

func reset():
	performosport = 0
	totalPerformo = 0
	maxPerformo = 5
	necroMax = 1
	_money = 0
	add_money(2000)
	
func get_upgrade(name):
	for upgrade in upgrades:
		if upgrade.name == name:
			return upgrade
	return null

func refresh_upgrades_effects():
	GameStateManager.player.update_fov()
	AudioManager.PerformoAudio()
	
func purge_upgrades():
	for upgrade in upgrades:
		upgrade.equipped = 0
	refresh_upgrades_effects()
	
func add_money(value):
	_money += value
	HUD.get_node("TopRightText").text = str(_money) + "b"
