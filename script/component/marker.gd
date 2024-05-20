extends Control

enum pointer_side {UP, LEFT, RIGHT}

@export var margin: int = 104
@export var target_position: int = 0:
	set(value):
		target_position = value
		update_position(target_position)


func _ready():
	pointer_reset()


func pointer_reset():
	%PointerUp.visible = false
	%PointerLeft.visible = false
	%PointerRight.visible = false


func update_position(value):
	position.x = clamp(
		value,
		margin,
		ProjectSettings.get_setting("display/window/size/viewport_width") - margin
	)

	# Pointer direction
	pointer_reset()
	if value < position.x:
			%PointerLeft.visible = true
	elif value > position.x:
			%PointerRight.visible = true
	else:
			%PointerUp.visible = true
