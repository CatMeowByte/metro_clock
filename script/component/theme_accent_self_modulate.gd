extends CanvasItem


func _ready():
	GlobalConfig.setting_updated.connect(_on_setting_updated)
	_on_setting_updated()


func _on_setting_updated():
	self_modulate = GlobalConfig.theme_color_accent
