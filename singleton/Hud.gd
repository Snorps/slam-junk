extends Control

const centre_text_show_time = 3
const fade_rate = 1.0

var centre_text_remaining_time = 0

func _process(delta):
	centre_text_remaining_time -= delta
	if centre_text_remaining_time <= 0:
		$CenterText.modulate.a -= delta * fade_rate

func set_centre_text(text, show_time = centre_text_show_time):
	$CenterText.text = text
	centre_text_remaining_time = show_time
	$CenterText.modulate.a = 1
	
func set_hands_text(text):
	$HandsText.text = text
