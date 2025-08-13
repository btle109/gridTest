extends Area3D
var tween : Tween
var door = preload("res://sound/doorClip.mp3")
var up = false
#bool only usable once
func use() -> void:
	if (!up):
		tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "transform", transform.translated_local(Vector3.UP * 3.75), 2.25)
		$doorSound.stream = door
		$doorSound.play()
		up = true
