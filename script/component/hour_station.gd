@tool
extends Node

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		%Outline.self_modulate = value
