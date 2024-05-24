extends Node

const WMO_WEATHER_NAME = {
		0: "Clear sky",
		1: "Mainly clear",
		2: "Partly cloudy",
		3: "Overcast",
		45: "Fog",
		48: "Depositing rime fog",
		51: "Slight drizzle",
		53: "Moderate drizzle",
		55: "Dense drizzle",
		56: "Light freezing drizzle",
		57: "Heavy freezing drizzle",
		61: "Slight rain",
		63: "Moderate rain",
		65: "Heavy rain",
		66: "Light freezing rain",
		67: "Heavy freezing rain",
		71: "Slight snow fall",
		73: "Moderate snow fall",
		75: "Heavy snow fall",
		77: "Snow grains",
		80: "Slight rain showers",
		81: "Moderate rain showers",
		82: "Violent rain showers",
		85: "Slight snow showers",
		86: "Heavy snow showers",
		95: "Thunderstorm",
		96: "Slight hail thunderstorm",
		99: "heavy hail thunderstorm",
}

@export var wmo_weather_image = {
		0: "Clear sky",
		1: "Mainly clear",
		2: "Partly cloudy",
		3: "Overcast",
		45: "Fog",
		48: "Depositing rime fog",
		51: "Slight drizzle",
		53: "Moderate drizzle",
		55: "Dense drizzle",
		56: "Light freezing drizzle",
		57: "Heavy freezing drizzle",
		61: "Slight rain",
		63: "Moderate rain",
		65: "Heavy rain",
		66: "Light freezing rain",
		67: "Heavy freezing rain",
		71: "Slight snow fall",
		73: "Moderate snow fall",
		75: "Heavy snow fall",
		77: "Snow grains",
		80: "Slight rain showers",
		81: "Moderate rain showers",
		82: "Violent rain showers",
		85: "Slight snow showers",
		86: "Heavy snow showers",
		95: "Thunderstorm",
		96: "Slight hail thunderstorm",
		99: "heavy hail thunderstorm",
}


func _ready():
	GlobalWeather.weather_updated.connect(update_weather)


func update_weather():
	var geocode_country = GlobalWeather.geocode[GlobalConfig.location_country_id].country
	var location_name = geocode_country.name
	if geocode_country.states:
		var geocode_state = geocode_country.states[wrap(GlobalConfig.location_state_id, 0, geocode_country.states.size())]
		location_name = geocode_state.name
		if geocode_state.cities:
			var geocode_city = geocode_state.cities[wrap(GlobalConfig.location_city_id, 0, geocode_state.cities.size())]
			location_name = geocode_city.name + ", " + location_name

	%Location.text = location_name
	%Unit.text = GlobalWeather.temperature_unit.trim_prefix("°")
	%Temperature.text = str(GlobalWeather.temperature)
	%Icon.texture = wmo_weather_image[GlobalWeather.weather_code]
	%Description.text = WMO_WEATHER_NAME[GlobalWeather.weather_code]
