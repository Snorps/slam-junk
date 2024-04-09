extends Node

var _money = 2000

var performosport
var performosport_unlocked

var necrogluterol_unlocked

var totalPerformo = 0
var maxPerformo = 5
var necroMax = 1

func _ready():
	reset()

func reset():
	performosport = 0
	performosport_unlocked = 0
	_money = 0
	add_money(2000)
	
func add_money(value):
	_money += value
	HUD.get_node("TopRightText").text = str(_money) + "b"
