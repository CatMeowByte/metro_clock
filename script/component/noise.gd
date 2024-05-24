extends CanvasItem


func _ready():
	GlobalTime.second_updated.connect(noise_chance)

	visible = false


func noise_chance():
	if randi_range(0, GlobalConfig.noise_stability) == 0:
		visible = true
		await get_tree().create_timer(randf_range(0.125, GlobalConfig.noise_duration)).timeout
		visible = false
