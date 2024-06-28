extends Control

const EVENT_NAME: Dictionary = {
	"fajr" : "Fajr",
	"dhuhr" : "Dhuhr",
	"asr" : "Asr",
	"maghrib" : "Maghrib",
	"isha" : "Isha",
}


func _ready():
	GlobalTime.marker_triggered.connect(popout)

	visible = true
	scale = Vector2.ZERO


func popout(marker):
	# Early bail
	if marker not in EVENT_NAME:
		return

	%Now.text = EVENT_NAME[marker]

	var pop

	# Pop in
	scale = Vector2.ZERO
	pop = get_tree().create_tween()
	pop.tween_property(self, "scale", Vector2.ONE, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	await pop.finished

	if not GlobalConfig.debug_time_travel:
		# Blink
		var blink = get_tree().create_tween().set_loops(20)
		blink.tween_property(%Now, "modulate", Color(Color.WHITE, 0.5), 0.5)
		blink.tween_property(%Now, "modulate", Color(Color.WHITE, 1.0), 0.5)

		await get_tree().create_timer(60).timeout

	# Pop out
	pop = get_tree().create_tween()
	pop.tween_property(self, "scale", Vector2.ZERO, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

