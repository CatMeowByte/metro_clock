extends Node

const EVENT_NAME: Dictionary = {
	"fajr" : "Fajr",
	"dhuhr" : "Dhuhr",
	"asr" : "Asr",
	"maghrib" : "Maghrib",
	"isha" : "Isha",
	"sunrise" : "Sunrise",
	"sunset" : "Sunset",
	"earlynight" : "Early Night",
	"latenight" : "Late Night",
	"yesternight" : "Early Night", # Yesterday's early night
	"tomonight" : "Late Night", # Tomorrow's late night
}


func _ready():
	# Initially trigger when hijri date is set, then update per minute
	GlobalDate.h_date_updated.connect(_on_h_date_updated)


func _on_minute_updated():
	var view_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var view_center = view_width / 2

	# Get previous and next marker
	var time_current = (GlobalTime.t.hour * 60) + GlobalTime.t.minute
	var key_prev = ""
	var key_next = ""
	var diff_prev = 24 * 60 # A day before
	var diff_next = 24 * 60 # A day after
	var m = GlobalTime.m # Reference
	for key in m:
		var diff = abs(time_current - m[key])
		if m[key] < time_current:
			if diff < diff_prev:
				diff_prev = diff
				key_prev = key
		else:
			if diff < diff_next:
				diff_next = diff
				key_next = key

	# Previous marker
	var abs_time_prev = wrap(m[key_prev], 0, 24 * 60)
	var rel_hour_prev = int(diff_prev / 60)
	var rel_minute_prev = diff_prev % 60
	%MarkerPrev.target_position = remap(diff_prev, 0, 2 * 60, view_center, 0)
	%MarkerPrev/%Event.text = EVENT_NAME[key_prev]
	%MarkerPrev/%Time.text = "{hour}:{minute} {period}".format({
		"hour" : GlobalTime.hour_12(abs_time_prev / 60),
		"minute" : str(abs_time_prev % 60).pad_zeros(2),
		"period" : "AM" if abs_time_prev < (12 * 60) else "PM",
	})
	%MarkerPrev/%Duration.text = "{value} {period} ago".format({
		"value" = rel_hour_prev if rel_hour_prev else rel_minute_prev,
		"period" = "hour" if rel_hour_prev else "min",
	})

	# Next marker
	var abs_time_next = wrap(m[key_next], 0, 24 * 60)
	var rel_hour_next = int(diff_next / 60)
	var rel_minute_next = diff_next % 60
	%MarkerNext.target_position = remap(diff_next, 0, 2 * 60, view_center, view_width)
	%MarkerNext/%Event.text = EVENT_NAME[key_next]
	%MarkerNext/%Time.text = "{hour}:{minute} {period}".format({
		"hour" : GlobalTime.hour_12(abs_time_next / 60),
		"minute" : str(abs_time_next % 60).pad_zeros(2),
		"period" : "AM" if abs_time_next < (12 * 60) else "PM",
	})
	%MarkerNext/%Duration.text = "{value} {period} later".format({
		"value" = rel_hour_next if rel_hour_next else rel_minute_next,
		"period" = "hour" if rel_hour_next else "min",
	})


func _on_h_date_updated():
	await get_tree().create_timer(1).timeout
	_on_minute_updated()
	GlobalDate.h_date_updated.disconnect(_on_h_date_updated)
	GlobalTime.minute_updated.connect(_on_minute_updated)
