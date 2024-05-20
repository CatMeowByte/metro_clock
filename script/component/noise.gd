extends CanvasItem


func _ready():
	GlobalTime.second_updated.connect(_on_second_updated)

	visible = false


func _on_second_updated():
	if randi_range(0, GlobalConfig.noise_stability) == 0:
		visible = true
		await get_tree().create_timer(randf_range(0.125, GlobalConfig.noise_duration)).timeout
		visible = false
