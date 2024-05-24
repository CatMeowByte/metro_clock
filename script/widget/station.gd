extends Control


func _ready():
	GlobalTime.hour_updated.connect(station_update)
	GlobalTime.minute_updated.connect(station_scroll)


func station_update():
	var hour = GlobalTime.t.hour
	%HourStationB2/%Number.text = str(GlobalTime.hour_12(hour - 2))
	%HourStationB1/%Number.text = str(GlobalTime.hour_12(hour - 1))
	%HourStationF0/%Number.text = str(GlobalTime.hour_12(hour + 0))
	%HourStationF1/%Number.text = str(GlobalTime.hour_12(hour + 1))
	%HourStationF2/%Number.text = str(GlobalTime.hour_12(hour + 2))
	%HourStationF3/%Number.text = str(GlobalTime.hour_12(hour + 3))


func station_scroll():
	var project_width = get_viewport_rect().size.x
	%StationScroll.scroll_horizontal = (GlobalTime.t.minute / 60.0) * (project_width / 4)
