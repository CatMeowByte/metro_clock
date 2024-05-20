extends Node
## Configuration

const CONFIG_PATH = "user://setting.config"
var config = ConfigFile.new()


# Debug
var debug_fake_api: bool
var debug_time_travel: bool
var debug_time_travel_speed: int

# Time
var time_12: bool

# Geocode
var location_country_id: int
var location_state_id: int
var location_city_id: int

# Running text
var running_text_scroll_speed: int
var running_text: Array

# Anti burn-in noise
var noise_stability: int
var noise_duration: float

func _init():
	config_load()
	config_save() # Precaution if no file exist

func config_load():
	if not config.load(CONFIG_PATH) == OK:
		printerr("Unable to load configuration file")

	var section: String

	# Debug
	section = "Debug"
	debug_fake_api = config.get_value(section, "debug_fake_api", false)
	debug_time_travel = config.get_value(section, "debug_time_travel", false)
	debug_time_travel_speed = config.get_value(section, "debug_time_travel_speed", 2000)

	# Time
	section = "Time"
	time_12 = config.get_value(section, "time_12", false)

	# Geocode
	section = "Geocode"
	location_country_id = config.get_value(section, "location_country_id", 0)
	location_state_id = config.get_value(section, "location_state_id", 0)
	location_city_id = config.get_value(section, "location_city_id", 0)

	# Running Text
	section = "RunningText"
	running_text_scroll_speed = config.get_value(section, "running_text_scroll_speed", 128)
	running_text = config.get_value(section, "running_text", [
		"The quick brown fox jumps over the lazy dog.",
		"Sphinx of black quartz, judge my vow.",
		"Pack my box with five dozen liquor jugs.",
	])

	# Anti burn-in noise
	section = "Noise"
	noise_stability = config.get_value(section, "noise_stability", 2000)
	noise_duration = config.get_value(section, "noise_duration", 5.0)


func config_save():
	var section: String

	# Debug
	section = "Debug"
	config.set_value(section, "debug_fake_api", debug_fake_api)
	config.set_value(section, "debug_time_travel", debug_time_travel)
	config.set_value(section, "debug_time_travel_speed", debug_time_travel_speed)

	# Time
	section = "Time"
	config.set_value(section, "time_12", time_12)

	# Geocode
	section = "Geocode"
	config.set_value(section, "location_country_id", location_country_id)
	config.set_value(section, "location_state_id", location_state_id)
	config.set_value(section, "location_city_id", location_city_id)

	# Running Text
	section = "RunningText"
	config.set_value(section, "running_text_scroll_speed", running_text_scroll_speed)
	config.set_value(section, "running_text", running_text)

	# Anti burn-in noise
	section = "Noise"
	config.get_value(section, "noise_stability", noise_stability)
	config.get_value(section, "noise_duration", noise_duration)

	if not config.save(CONFIG_PATH) == OK:
		printerr("Unable to save configuration file")