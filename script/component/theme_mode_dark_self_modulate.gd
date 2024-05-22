extends CanvasItem

@export_group("Dark Mode", "color_")
@export var color_light: Color = Color.GRAY
@export var color_dark: Color = Color.DIM_GRAY


func _ready():
	GlobalConfig.setting_updated.connect(_on_setting_updated)
	_on_setting_updated()


func _on_setting_updated():
	self_modulate = color_dark if GlobalConfig.theme_mode_dark else color_light
