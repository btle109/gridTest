extends Area3D
@export var Connectable = Area3D
@export var setText = ""
@export var label : Label;
func _ready():
	$TextBox/Panel/Label.text = setText;
func use():
	#if (Connectable.has_method("unlock")):
	Connectable.unlock()
	Connectable.use()
	$TextBox.visible = true;
	get_tree().paused = true
	label.text = ""

func _input(event: InputEvent) -> void:
	if not event is InputEventMouse:
		if ($TextBox.visible == true):
			get_tree().paused = false;
			$TextBox.visible = false;
