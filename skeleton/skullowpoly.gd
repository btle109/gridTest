extends CharacterBody3D

@export var MoveSpeed: float = 3.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var is_attacking = false
var player: Node3D = null
var origin: Node3D = null
var in_range = false
var alive = true
var HP = 50

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	origin = get_tree().get_nodes_in_group("origins")[0]
	$View.body_entered.connect(_on_attack_zone_body_entered)
	$View.body_exited.connect(_on_attack_zone_body_exited)
	
func _physics_process(_delta: float) -> void:
	if alive:
		if is_attacking:
			return
		$AnimationPlayer.play("skelChar|Walk")
		if (in_range):
			navigation_agent.set_target_position(player.global_position)
		else:
			navigation_agent.set_target_position(origin.global_position)

		if navigation_agent.is_navigation_finished():
			return
		var next_position: Vector3 = navigation_agent.get_next_path_position()
		var direction = global_position.direction_to(next_position)

		direction.y = 0
		direction = direction.normalized()

		if direction.length() > 0.00001:
			var target_rotation = atan2(direction.x, direction.z)
			var current_rotation = rotation.y
			rotation.y = lerp_angle(current_rotation, target_rotation, 8 * _delta)
			
		velocity = direction * MoveSpeed
		move_and_slide()
	else:
		queue_free()
func _on_attack_zone_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		is_attacking = true
		velocity = Vector3.ZERO
		$AnimationPlayer.play("skelChar|skelAttack")


func _on_attack_zone_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		is_attacking = false
		$AnimationPlayer.play("skelChar|rest")

func _on_enemy_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_range = true

func _on_enemy_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_range = false

func hurt(dmg, _atk, _def) -> void:
	HP -= dmg
	if (HP <= 0):
		alive = false
	
func attack() -> void:
	if (is_attacking):
		print("ow")
		player.hurt(10,0.6,0.3)
