extends Node

signal hour_updated
signal minute_updated
signal second_updated
signal marker_triggered

var debug_unix_time: float = Time.get_unix_time_from_system()

var t: Dictionary = {
	"hour" : -1,
	"minute" : -1,
	"second" : -1,
}

# Populated by GlobalDate API
# Uses minute-base linear integer, 1440 minutes in a day
var m: Dictionary = {
	"fajr" : -1,
	"dhuhr" : -1,
	"asr" : -1,
	"maghrib" : -1,
	"isha" : -1,
	"sunrise" : -1,
	"earlynight" : -1,
	"latenight" : -1,
	"yesternight" : -1, # Yesterday's early night
	"tomonight" : -1, # Tomorrow's late night
}

var time_minute_base: int = -1


func _ready():
	minute_updated.connect(_on_minute_updated)


func _process(delta):
	var system_time = Time.get_time_dict_from_system()

	# Debug
	if GlobalConfig.debug_time_travel:
		system_time = Time.get_time_dict_from_unix_time(int(debug_unix_time))
		debug_unix_time += delta * GlobalConfig.debug_time_travel_speed

	if not t.hour == system_time.hour:
		t.hour = system_time.hour
		emit_signal("hour_updated")
	if not t.minute == system_time.minute:
		t.minute = system_time.minute
		emit_signal("minute_updated")
	if not t.second == system_time.second:
		t.second = system_time.second
		emit_signal("second_updated")


# Convert to 12H format
func hour_12(hour: int):
	return (hour + 11) % 12 + 1


# Convert string time (e.g. "08:25") into minute base integer (1440)
func string_to_minute_base(text: String):
	var split = text.split(":")
	return (60 * int(split[0])) + int(split[1])


func _on_minute_updated():
	time_minute_base = (GlobalTime.t.hour * 60) + GlobalTime.t.minute

	for marker in m:
		if m[marker] == time_minute_base:
			emit_signal("marker_triggered", marker)


func is_nighttime():
	return not (m.fajr <= time_minute_base < m.maghrib)
