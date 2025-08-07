extends CharacterBody3D

@export var MoveSpeed: float = 3.0
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var is_attacking = false
const DEF_CHANCE = 50
const ATK_CHANCE = 70
var player: Node3D = null
var origin: Node3D = null
var in_range = false
var alive = true
var HP = 50
var sound = preload("res://sound/skeletonscream.mp3")
var sound2 = preload("res://sound/skeletonscream2.mp3")

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

func hurt(dmg) -> void:
	#player successful attack
	var prob = randi()%100 + 1
	var hitsound
	if (prob < DEF_CHANCE):
		hitsound = load("res://sound/swordclash.mp3")
		$hitsounds.stream = hitsound
		$hitsounds.play()
		HP -= 0.4 * dmg + randi()%4
		print("ENEMY ", HP, " PLAYER ATTACK DEFENDED")
	else:
		hitsound = load("res://sound/smashsound.mp3")
		$hitsounds.stream = hitsound
		#play enemy stun anim
		$hitsounds.play()
		HP -= dmg + randi()%7
		print("ENEMY ", HP, " PLAYER ATTACK SUCCESS")
	if (HP <= 0):
		alive = false
	
func attack() -> void:
	if (is_attacking):
		if (!$AudioStreamPlayer3D.is_playing()):
			$AudioStreamPlayer3D.stream = sound
			$AudioStreamPlayer3D.play()
		player.hurt(10)

func _on_timer_timeout() -> void:
	if (randi()%100+1 < 40):
		if (!$AudioStreamPlayer3D.is_playing()):
				$AudioStreamPlayer3D.stream = sound2
				$AudioStreamPlayer3D.play()
