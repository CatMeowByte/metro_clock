extends Control

signal setting_pressed

@export var distance_min: int = 160
@export var distance_max: int = 96

func _ready():
	dissapear()

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


func dissapear():
	modulate.a = 0
	visible = true


func fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func setting():
	emit_signal("setting_pressed")


func restart():
	OS.set_restart_on_exit(true)
	get_tree().quit()


func close():
	get_tree().quit()
