extends CanvasItem

@export_group("Theme Mode", "color_")
@export var color_light: Color = Color.GRAY
@export var color_dark: Color = Color.DIM_GRAY


func _ready():
	GlobalConfig.setting_updated.connect(color_update)
	GlobalTime.minute_updated.connect(color_update)
	color_update()


func color_update():
	var is_night = (
		GlobalTime.time_minute_base < GlobalTime.m.sunrise
		or GlobalTime.time_minute_base >= GlobalTime.m.maghrib
	)
	var is_dark = GlobalConfig.theme_mode == 1 or (GlobalConfig.theme_mode == 2 and is_night)
	self_modulate = color_dark if is_dark else color_light
