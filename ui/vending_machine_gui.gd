extends Control


var performoLabel
var performoLabel2
var necroLabel
var control
var performoContainer
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	performoContainer = get_node("PerformoContainer")
	control = get_node("Control")
	performoLabel = get_node("Control/PerformoLabel")
	necroLabel = get_node("Control/NecroLabel")
	performoLabel2 = get_node("Control/PerformoLabel2")
	
func _process(delta):
	pass

func UpdateLabels():
	var counter = Flags.performosport
	for child in performoContainer.get_children():
		if(counter > 0):
			child.color = Color(0.5, 0.5, 0.5, 1.0)
			counter -= 1
		else:
			child.color = Color(1.0,1.0,1.0,1.0)
	
func UpdateText():
	var text
	if(Flags.performosport < Flags.totalPerformo):
		text = "0"
	else:
		text = "five fives"
	performoLabel.text = "Moneycosts: " + text + "\nAmountsof: " + str(Flags.performosport) + "\nMAXOPERFORMO: FIVE"
	
	text = str(Flags.totalPerformo)
	performoLabel2.text = "Refundables: " + text
	
func _on_performosport_pressed():
	
	Flags.add_money(-25)
	if(Flags.performosport <= Flags.totalPerformo):
		if(Flags.performosport != Flags.maxPerformo):
			Flags.performosport += 1
		if(Flags.performosport > Flags.totalPerformo && Flags.totalPerformo < Flags.maxPerformo):
			Flags.totalPerformo = Flags.performosport
		
	GameStateManager.player.update_fov()
	UpdateText()
	UpdateLabels()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	hide()
	
func _on_necrogluterol_pressed():
	Flags.add_money(-15)
	GameStateManager.player.get_node("Damageable").health = 0
	GameStateManager.lose_game()


func _on_quit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
