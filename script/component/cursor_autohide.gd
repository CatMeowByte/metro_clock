extends Timer


func _input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		start()


func _on_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
