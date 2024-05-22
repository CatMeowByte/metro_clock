extends Control

enum pointer_side {UP, LEFT, RIGHT}

@export var margin: int = 104
@export var target_position: int = 0:
	set(value):
		target_position = value

		if not is_node_ready():
			await ready

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
		get_viewport_rect().size.x - margin
	)

	# Pointer direction
	pointer_reset()
	if value < position.x:
			%PointerLeft.visible = true
	elif value > position.x:
			%PointerRight.visible = true
	else:
			%PointerUp.visible = true
