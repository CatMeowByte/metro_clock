extends Control

@export var footer_notify_time: float = 5.0

func _ready():
	button_update()

	%NoticeRestart.visible = false
	%Footer/Notifier.visible = false
	%Footer/Button.visible = true

	visible = true
	position.y = -get_viewport_rect().size.y

	# Remove debug tab on release
	if not OS.is_debug_build():
		%Tab/Debug.queue_free()


func setting_update():
	data_update()
	button_update()


func data_update():
	# Debug
	GlobalConfig.debug_fake_api = %FakeAPI/CheckBox.is_pressed()
	GlobalConfig.debug_time_travel = %TimeTravel/CheckBox.is_pressed()
	GlobalConfig.debug_time_travel_speed = %TimeTravel/SpinBox.get_value()

	# Theme
	for child in %ColorAccent.get_children():
		if child.button_pressed:
			GlobalConfig.theme_color_accent = child.self_modulate
	GlobalConfig.theme_mode = %ThemeMode/OptionButton.get_selected_id()

	# Time
	GlobalConfig.hour_12 = %Hour12/CheckBox.is_pressed()
	GlobalConfig.calculation_method = %CalculationMethod/OptionButton.get_selected_id()
	GlobalConfig.latitude_method = %LatitudeMethod/OptionButton.get_selected_id()
	GlobalConfig.shafaq = %Shafaq/OptionButton.get_selected_id()
	GlobalConfig.hanafi = %Hanafi/CheckBox.is_pressed()

	# Geocode
	GlobalConfig.location_country_id = %Country/OptionButton.get_selected_id()
	GlobalConfig.location_state_id = %State/OptionButton.get_selected_id()
	GlobalConfig.location_city_id = %City/OptionButton.get_selected_id()

	# Running Text
	GlobalConfig.running_text_scroll_speed = %RunningSpeed/SpinBox.get_value()

	# Strip redundant newline
	GlobalConfig.running_text = []
	var array_text = %RunningText/TextEdit.text.split("\n")
	for text in array_text:
		if text:
			GlobalConfig.running_text.append(text)

	GlobalConfig.running_randomize = %RunningRandomize/CheckBox.is_pressed()

	# Anti burn-in noise
	GlobalConfig.noise_stability = %NoiseStability/SpinBox.get_value()
	GlobalConfig.noise_duration = %NoiseDuration/SpinBox.get_value()

	GlobalConfig.emit_signal("setting_updated")


func button_update():
	# Reusable current button
	var button

	#region Debug
	# Fake API
	button = %FakeAPI/CheckBox
	button.button_pressed = GlobalConfig.debug_fake_api

	# Time Travel
	button = %TimeTravel/CheckBox
	button.button_pressed = GlobalConfig.debug_time_travel
	button = %TimeTravel/SpinBox
	button.set_value_no_signal(GlobalConfig.debug_time_travel_speed)
	#endregion

	#region Theme
	# Color Accent
	button = %ColorAccent
	for child in button.get_children():
		if not child.pressed.is_connected(_on_button_pressed):
			child.pressed.connect(_on_button_pressed)
		child.button_pressed = child.self_modulate == GlobalConfig.theme_color_accent

	# Theme Mode
	button = %ThemeMode/OptionButton
	button.select(GlobalConfig.theme_mode)
	#endregion

	#region Time
	# Hour 12
	button = %Hour12/CheckBox
	button.button_pressed = GlobalConfig.hour_12

	# Calculation Method
	button = %CalculationMethod/OptionButton
	button.select(GlobalConfig.calculation_method)

	# Latitude Method
	button = %LatitudeMethod/OptionButton
	button.select(GlobalConfig.latitude_method)

	# Shafaq
	button = %Shafaq/OptionButton
	button.select(GlobalConfig.shafaq)

	# Hanafi
	button = %Hanafi/CheckBox
	button.button_pressed = GlobalConfig.hanafi
	#endregion

	#region Running Text
	# Speed
	button = %RunningSpeed/SpinBox
	button.set_value_no_signal(GlobalConfig.running_text_scroll_speed)

	# Text
	button = %RunningText/TextEdit
	button.text = "\n".join(GlobalConfig.running_text)

	# Randomize
	button = %RunningRandomize/CheckBox
	button.button_pressed = GlobalConfig.running_randomize
	#endregion

	#region Geocode
	var geocode = GlobalWeather.geocode # Reference

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
	#endregion

	#region Noise
	# Stability
	button = %NoiseStability/SpinBox
	button.set_value_no_signal(GlobalConfig.noise_stability)

	# Duration
	button = %NoiseDuration/SpinBox
	button.set_value_no_signal(GlobalConfig.noise_duration)
	#endregion

	if OS.has_feature("editor"):
		print("button updated")


func footer_pressed(text: String):
	%Footer/Notifier.text = "Settings " + text
	%Footer/Notifier.visible = true
	%Footer/Button.visible = false
	await get_tree().create_timer(footer_notify_time).timeout
	%Footer/Notifier.visible = false
	%Footer/Button.visible = true


func _on_focus_exited():
	setting_update()


func _on_button_value_pressed(value):
	if OS.has_feature("editor"):
		print("button pressed value is ", value)
	setting_update()


func _on_button_pressed():
	setting_update()


func _on_interface_setting_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_interface_close_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -get_viewport_rect().size.y, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)


func _on_interface_reset_pressed():
	GlobalConfig.config_set(true)
	button_update()
	footer_pressed("Reset!")


func _on_interface_save_pressed():
	GlobalConfig.config_save()
	button_update()
	%NoticeRestart.visible = true
	footer_pressed("Saved!")
