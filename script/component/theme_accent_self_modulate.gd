extends CanvasItem


func _ready():
	GlobalConfig.setting_updated.connect(color_update)
	color_update()


func color_update():
	self_modulate = GlobalConfig.theme_color_accent
