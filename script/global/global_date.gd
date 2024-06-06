extends Node
## API specific hijri and prayer times
## Currently using AlAdhan: https://aladhan.com

signal g_year_updated
signal g_month_updated
signal g_day_updated
signal h_date_updated

const API_URL = "https://api.aladhan.com/v1/timings/{day}-{month}-{year}?latitude={latitude}&longitude={longitude}&method={calculation_method}&latitudeAdjustmentMethod={latitude_method}&shafaq={shafaq}&school={hanafi}"

var HTTP: HTTPRequest

var g: Dictionary = {
	"year" : -1,
	"month" : -1,
	"day" : -1,
	"weekday" : -1,
}

var h: Dictionary = {
	"year" : -1,
	"month" : -1,
	"day" : -1,
}


func _ready():
	GlobalTime.hour_updated.connect(_on_hour_updated)
	g_day_updated.connect(_on_day_updated)

	# Create HTTP request node
	HTTP = HTTPRequest.new()
	HTTP.set_timeout(10)
	add_child(HTTP)
	HTTP.request_completed.connect(_on_request_completed)


func _on_hour_updated():
	var system_date = Time.get_date_dict_from_system()
	if not g.year == system_date.year:
		g.year = system_date.year
		emit_signal("g_year_updated")
	if not g.month == system_date.month:
		g.month = system_date.month
		emit_signal("g_month_updated")
	if not g.day == system_date.day:
		g.day = system_date.day
		g.weekday = system_date.weekday
		emit_signal("g_day_updated")


func date_update():
	# Debug
	if GlobalConfig.debug_fake_api:
		var data = { "code": 200, "status": "OK", "data": { "timings": { "Fajr": "02:55", "Sunrise": "04:37", "Dhuhr": "11:40", "Asr": "15:28", "Sunset": "18:44", "Maghrib": "18:44", "Isha": "20:19", "Imsak": "02:45", "Midnight": "23:40", "Firstthird": "22:02", "Lastthird": "01:19" }, "date": { "readable": "14 May 2024", "timestamp": "1715653800", "hijri": { "date": "06-11-1445", "format": "DD-MM-YYYY", "day": "06", "weekday": { "en": "Al Thalaata", "ar": "الثلاثاء" }, "month": { "number": 11, "en": "Dhū al-Qaʿdah", "ar": "ذوالقعدة" }, "year": "1445", "designation": { "abbreviated": "AH", "expanded": "Anno Hegirae" }, "holidays": [] }, "gregorian": { "date": "14-05-2024", "format": "DD-MM-YYYY", "day": "14", "weekday": { "en": "Tuesday" }, "month": { "number": 5, "en": "May" }, "year": "2024", "designation": { "abbreviated": "AD", "expanded": "Anno Domini" } } }, "meta": { "latitude": 36.68333, "longitude": 71.53333, "timezone": "Asia/Kabul", "method": { "id": 3, "name": "Muslim World League", "params": { "Fajr": 18, "Isha": 17 }, "location": { "latitude": 51.5194682, "longitude": -0.1360365 } }, "latitudeAdjustmentMethod": "ANGLE_BASED", "midnightMode": "STANDARD", "school": "STANDARD", "offset": { "Imsak": 0, "Fajr": 0, "Sunrise": 0, "Dhuhr": 0, "Asr": 0, "Maghrib": 0, "Sunset": 0, "Isha": 0, "Midnight": 0 } } } }
		data_handle(data)
		return

	var request = HTTP.request(
		API_URL.format({
			"day": str(g.day).pad_zeros(2),
			"month": str(g.month).pad_zeros(2),
			"year": str(g.year).pad_zeros(4),
			"latitude": str(GlobalWeather.latitude),
			"longitude": str(GlobalWeather.longitude),
			"calculation_method": str(GlobalConfig.calculation_method),
			"latitude_method": str(GlobalConfig.latitude_method),
			"shafaq": str({0: "general", 1: "ahmer", 2: "abyad"}[GlobalConfig.shafaq]),
			"hanafi": str(int(GlobalConfig.hanafi)),
		})
	)
	if not request == OK:
		printerr("An error occurred in the Date API HTTP request.")


func data_handle(data: Dictionary):
	data = data.data # Go to data

	# Hijri date
	h.year = int(data.date.hijri.year)
	h.month = int(data.date.hijri.month.number)
	h.day = int(data.date.hijri.day)

	var to_min: Callable = func (text):
		return GlobalTime.string_to_minute_base(data.timings[text])

	# Marker
	var m = GlobalTime.m # Reference
	m.fajr = to_min.call("Fajr")
	m.dhuhr = to_min.call("Dhuhr")
	m.asr = to_min.call("Asr")
	m.maghrib = to_min.call("Maghrib")
	m.isha = to_min.call("Isha")
	m.sunrise = to_min.call("Sunrise")
	m.earlynight = to_min.call("Firstthird")
	m.latenight = to_min.call("Lastthird")

	# Faked to save bandwidth
	m.yesternight = m.earlynight - (24 * 60)
	m.tomonight = m.latenight + (24 * 60)
	emit_signal("h_date_updated")


func _on_day_updated():
	date_update()


func _on_request_completed(result, _response_code, _headers, body):
	var request_retry: Callable = func ():
		print("Retrying Date API HTTP request...")
		await get_tree().create_timer(5).timeout
		date_update()

	if not result == HTTPRequest.RESULT_SUCCESS:
		printerr("Date API HTTP request failed.")
		request_retry.call()
		return

	var data = JSON.parse_string(body.get_string_from_utf8())
	if not data:
		printerr("Date API JSON parse failed.")
		request_retry.call()
		return

	data_handle(data)
