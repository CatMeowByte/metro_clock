extends Node
## API specific weather
## Currently using Open-Meteo: https://open-meteo.com

signal weather_updated

const API_URL = "https://api.open-meteo.com/v1/forecast?latitude={latitude}&longitude={longitude}&current=apparent_temperature,weather_code&timezone=auto&forecast_days=1"

var HTTP: HTTPRequest

var latitude: String = ""
var longitude: String = ""

var temperature_unit: String = ""
var temperature: int = 0
var weather_code: int = 0

@onready var geocode: Array = ResourceLoader.load(
		"res://resource/countries_states_cities.json",
		"JSON"
).data


func _ready():
	GlobalTime.hour_updated.connect(_on_hour_updated)

	# Create HTTP request node
	HTTP = HTTPRequest.new()
	add_child(HTTP)
	HTTP.request_completed.connect(_on_request_completed)

	var geocode_data = geocode_load()
	latitude = geocode_data.latitude
	longitude = geocode_data.longitude

func weather_update():
	# Debug
	if GlobalConfig.debug_fake_api:
		var data = {"latitude":36.625,"longitude":71.375,"generationtime_ms":0.05805492401123047,"utc_offset_seconds":16200,"timezone":"Asia/Kabul","timezone_abbreviation":"+0430","elevation":3076.0,"current_units":{"time":"iso8601","interval":"seconds","apparent_temperature":"°C","weather_code":"wmo code"},"current":{"time":"2024-05-11T10:45","interval":900,"apparent_temperature":13.6,"weather_code":0}}
		data_handle(data)
		return

	var request = HTTP.request(API_URL.format({"latitude": latitude, "longitude": longitude}))
	if not request == OK:
		printerr("An error occurred in the Weather API HTTP request.")


func data_handle(data: Dictionary):
	temperature_unit = data.current_units.apparent_temperature
	temperature = data.current.apparent_temperature
	weather_code = data.current.weather_code
	emit_signal("weather_updated")


func geocode_load():
	var geocode_country = geocode[GlobalConfig.location_country_id].country
	if geocode_country.states:
		var geocode_state = geocode_country.states[GlobalConfig.location_state_id]
		if geocode_state.cities:
			var geocode_city = geocode_state.cities[GlobalConfig.location_city_id]
			return geocode_city
		else:
			return geocode_state
	else:
		return geocode_country


func _on_hour_updated():
	weather_update()


func _on_request_completed(result, _response_code, _headers, body):
	var request_retry: Callable = func ():
		print("Retrying Weather API HTTP request...")
		await get_tree().create_timer(5).timeout
		weather_update()

	if not result == HTTPRequest.RESULT_SUCCESS:
		printerr("Weather API HTTP request failed.")
		request_retry.call()

	var data = JSON.parse_string(body.get_string_from_utf8())
	if not data:
		printerr("Weather API JSON parse failed.")
		request_retry.call()

	data_handle(data)
