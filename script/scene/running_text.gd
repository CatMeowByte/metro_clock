extends Node

@export var text_object: PackedScene

var child: Label


func _ready():
	GlobalConfig.setting_updated.connect(child_populate)

	child_populate()


func _process(delta):
	child.custom_minimum_size.x -= delta * GlobalConfig.running_text_scroll_speed
	if child.custom_minimum_size.x <= 0:
		child_reorder()
		child_select()


func child_populate():
	child_delete()
	for text in GlobalConfig.running_text:
		child_create(text)
		child_create("        ")
	child_select()


func child_create(text: String):
	var obj = text_object.instantiate()
	obj.text = text
	%TextBox.add_child(obj)


func child_select():
	child = %TextBox.get_child(0)
	child.custom_minimum_size.x = child.size.x
	child.clip_text = true


func child_reorder():
	child.custom_minimum_size.x = 0
	%TextBox.move_child(child, -1)
	child.clip_text = false


func child_delete():
	for node in %TextBox.get_children():
		node.free()
