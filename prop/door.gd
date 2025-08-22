extends Area3D
var tween : Tween
var door = preload("res://sound/doorClip.mp3")
var up = false
@export var locked = false;
@export var label : Label

#bool only usable once
func lock() -> void:
	locked = true;
func unlock() -> void:
	locked = false;
func use() -> void:
	if locked:
		label.text = "The door is locked."
		label.reset()
	else:
		if (!up):
			tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "transform", transform.translated_local(Vector3.UP * 3.75), 2.25)
			$doorSound.stream = door
			$doorSound.play()
			up = true
			label.text = "The door opens."
			label.reset()
