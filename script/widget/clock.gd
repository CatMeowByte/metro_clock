extends Node


func _ready():
	GlobalTime.hour_updated.connect(_on_hour_updated)
	GlobalTime.minute_updated.connect(_on_minute_updated)
	GlobalTime.second_updated.connect(_on_second_updated)


func _on_hour_updated():
	%Hour.text = str(GlobalTime.hour_12(GlobalTime.t.hour))

	# AM/PM
	%Period.text = "AM" if GlobalTime.t.hour < 12 else "PM"


func _on_minute_updated():
	%Minute.text = str(GlobalTime.t.minute).pad_zeros(2)


func _on_second_updated():
	%Blinker.visible = GlobalTime.t.second % 2
