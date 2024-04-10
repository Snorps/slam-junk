extends Control

@export var upgrade_container_scene: PackedScene

var control
var performoContainer
var upgrades = [
	{
		"name"="performosport",
		"price"=25
	},	
	{
		"name"="necrogluterol",
		"price"=15
	},	
	{
		"name"="bicepscene",
		"price"=32
	},	
	{
		"name"="sportimax",
		"price"=25
	},	
	{
		"name"="skedaddlide",
		"price"=25
	},	
	{
		"name"="performosport",
		"price"=25
	},	
]
var containers = []

func _ready():
	GameStateManager.vending_machine_ui = self
	for upgrade in Flags.upgrades:
		var container = upgrade_container_scene.instantiate()
		container.upgrade = upgrade
		containers.append(container)
		$VerticalContainer.add_child(container)
		

func _on_necrogluterol_pressed():
	Flags.add_money(-15)
	GameStateManager.player.get_node("Damageable").health = 0
	GameStateManager.lose_game()

func update():
	for container in containers:
		container.update()

func _on_quit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
