extends Node


func _ready():
	GlobalTime.hour_updated.connect(hour_update)
	GlobalTime.minute_updated.connect(minute_update)
	GlobalTime.second_updated.connect(second_blink)

	GlobalConfig.setting_updated.connect(period_toggle)


func hour_update():
	%Hour.text = str(GlobalTime.hour_12(GlobalTime.t.hour) if GlobalConfig.hour_12 else GlobalTime.t.hour)

	# AM/PM
	%Period.text = "AM" if GlobalTime.t.hour < 12 else "PM"


func minute_update():
	%Minute.text = str(GlobalTime.t.minute).pad_zeros(2)


func second_blink():
	%Blinker.visible = GlobalTime.t.second % 2


func period_toggle():
	%Period.visible = GlobalConfig.hour_12
	hour_update()
