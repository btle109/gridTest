extends Area3D
var player : Node3D
@export var label : Label
func _ready()->void:
	player = get_tree().get_nodes_in_group("Player")[0]
func use() -> void:
	if (player.HP < 100):
		label.text = "Your wounds are healed."
		$AudioStreamPlayer3D.play()
	else:
		label.text = "You feel nothing."
	player.HP = 100
	label.reset()
	
