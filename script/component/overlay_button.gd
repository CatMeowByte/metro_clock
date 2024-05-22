extends Control

signal setting_pressed

@export var distance_min: int = 160
@export var distance_max: int = 96

func _ready():
	modulate.a = 0
	visible = true

func _input(event):
	if not event is InputEventMouseMotion:
		return

	modulate.a = clamp(remap(
		global_position.distance_to(get_viewport().get_mouse_position()),
		distance_min,
		distance_max,
		0,
		1
	), 0, 1)


func _on_fullscreen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_setting_pressed():
	emit_signal("setting_pressed")


func _on_restart_pressed():
	OS.create_process(OS.get_executable_path(), [])
	get_tree().quit()


func _on_close_pressed():
	get_tree().quit()
