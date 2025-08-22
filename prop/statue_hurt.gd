extends CharacterBody3D
var player : Node3D
func _ready()->void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
func hurt(_dmg) -> void:
	player.hurt(25)
