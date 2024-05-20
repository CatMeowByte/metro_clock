extends Node


func _ready():
	GlobalTime.hour_updated.connect(_on_hour_updated)
	GlobalTime.minute_updated.connect(_on_minute_updated)


func _on_hour_updated():
	var hour = GlobalTime.t.hour
	%HourStationB2/%Number.text = str(GlobalTime.hour_12(hour - 2))
	%HourStationB1/%Number.text = str(GlobalTime.hour_12(hour - 1))
	%HourStationF0/%Number.text = str(GlobalTime.hour_12(hour + 0))
	%HourStationF1/%Number.text = str(GlobalTime.hour_12(hour + 1))
	%HourStationF2/%Number.text = str(GlobalTime.hour_12(hour + 2))
	%HourStationF3/%Number.text = str(GlobalTime.hour_12(hour + 3))


func _on_minute_updated():
	var project_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	%StationScroll.scroll_horizontal = (GlobalTime.t.minute / 60.0) * (project_width / 4)
