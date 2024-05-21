extends Control

func _ready():
	button_update()


func data_update():
	# Debug
	#GlobalConfig.debug_fake_api = %Country/OptionButton.get_selected_id()
	#debug_time_travel = config.get_value(section, "debug_time_travel", false)
	#debug_time_travel_speed = config.get_value(section, "debug_time_travel_speed", 2000)

	# Time
	#GlobalConfig.time_12 = %Country/OptionButton.get_selected_id()

	# Geocode
	GlobalConfig.location_country_id = %Country/OptionButton.get_selected_id()
	GlobalConfig.location_state_id = %State/OptionButton.get_selected_id()
	GlobalConfig.location_city_id = %City/OptionButton.get_selected_id()

	# Running Text
	#running_text_scroll_speed = config.get_value(section, "running_text_scroll_speed", 128)
	#running_text =

	# Anti burn-in noise
	#noise_stability = config.get_value(section, "noise_stability", 2000)
	#noise_duration = config.get_value(section, "noise_duration", 5.0)


func button_update():
	# Reference
	var geocode = GlobalWeather.geocode
	var button

	# Country
	button = %Country/OptionButton

	# Only once
	if not button.item_count:
		button.clear()
		for countries in geocode:
			button.add_item(countries.country.name)
	button.select(GlobalConfig.location_country_id)
	var geocode_country = geocode[button.get_selected_id()].country

	# State
	%State.visible = not geocode_country.states.is_empty()
	%City.visible = %State.visible
	if %State.visible:
		button = %State/OptionButton
		button.clear()
		for state in geocode_country.states:
			button.add_item(state.name)
		button.select(GlobalConfig.location_state_id)
		var geocode_state = geocode_country.states[button.get_selected_id()]

		# City
		%City.visible = not geocode_state.cities.is_empty()
		if %City.visible:
			button = %City/OptionButton
			button.clear()
			for city in geocode_state.cities:
				button.add_item(city.name)
			button.select(GlobalConfig.location_city_id)


func panel_show():
	visible = true


func panel_hide():
	visible = false


func _on_button_pressed(value):
	print("button pressed value is ", value)
	data_update()
	button_update()


func _on_button_setting_pressed():
	panel_show()


func _on_button_close_pressed():
	panel_hide()
