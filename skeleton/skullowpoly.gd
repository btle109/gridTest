extends CharacterBody3D

@export var MoveSpeed: float = 3.0
@export var orig = Node3D
@export var enemyRange = Area3D
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@export var label : Label 
const DEF_CHANCE = 50
const ATK_CHANCE = 50
var HP = 60

var player: Node3D = null

var is_attacking = false #if player is in ViewCol, meaning begin attack anim
var in_range = false  #if player is in Enemy Range
var stunned = false;

var alive = true
var dead = false
var sound = preload("res://sound/skeletonscream.mp3")
var sound2 = preload("res://sound/skeletonscream2.mp3")

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	enemyRange.body_entered.connect(_on_enemy_range_body_entered)
	enemyRange.body_exited.connect(_on_enemy_range_body_exited)
#	$View.body_entered.connect(_on_attack_zone_body_entered)
#	$View.body_exited.connect(_on_attack_zone_body_exited)
	
func _physics_process(_delta: float) -> void:
	global_position.y = 0
	if alive:
		if is_attacking:
			return
		$AnimationPlayer.play("skelChar|Walk")

		if (in_range):
			navigation_agent.set_target_position(player.global_position)
		else:
			navigation_agent.set_target_position(orig.global_position)
			
		if navigation_agent.is_navigation_finished():
			$AnimationPlayer.play("skelChar|rest")
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
		die()
		
func _on_attack_zone_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and alive:
		is_attacking = true
		attack()
		
func _on_attack_zone_body_exited(body: Node) -> void:
	if body.is_in_group("Player") and alive:
		is_attacking = false
		$AnimationPlayer.play("skelChar|rest")
	
func attack() -> void:
	if (!in_range or stunned):
		return
	if ($AnimationPlayer.current_animation != "skelChar|skelAttack"):
		$AnimationPlayer.play("skelChar|skelAttack")

func animAttack() -> void:
	player.hurt(10)
	if (!$screaming.is_playing()):
		$screaming.stream = sound
		$screaming.play()

func die():
	if (!dead):
		$AnimationPlayer.play("newAnimfbx/skelChar|die")
		dead = true
		$Timer.stop()
		$removeArea/removeBox.disabled = false

func _on_enemy_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_range = true

func _on_enemy_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		in_range = false

func hurt(dmg) -> void:
	#player successful attack
	if (alive):
		var prob = randi()%100 + 1
		var hitsound
		if (prob < DEF_CHANCE):
			hitsound = load("res://sound/swordclashshort.mp3")
			$hitsounds.stream = hitsound
			$hitsounds.play()
			HP -= 0.4 * dmg + randi()%4
			print("ENEMY ", HP, " PLAYER ATTACK DEFENDED")
		else:
			hitsound = load("res://sound/smashsound.mp3")
			$hitsounds.stream = hitsound
			stunned = true
			$AnimationPlayer.play("newAnimfbx/skelChar|Stun")
			$hitsounds.play()
			HP -= dmg + randi()%7
			print("ENEMY ", HP, " PLAYER ATTACK SUCCESS")
	if (HP <= 0):
		alive = false


func _on_timer_timeout() -> void:
	if (randi()%100+1 < 25):
		if (randi()%2 == 0):
			$screaming.stream = sound2
			$screaming.play()
		else:
			$steps.stream = load("res://sound/concrete-footsteps-6752.mp3")
			$steps.play()

func use() -> void:
	label.text = "A skeleton."
	label.reset();
	queue_free();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "newAnimfbx/skelChar|Stun"):
		stunned = false
		attack();
