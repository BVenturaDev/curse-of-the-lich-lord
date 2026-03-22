extends CharacterBody3D
class_name enemy

@export var nav_agent: NavigationAgent3D
@export var state_machine: Node
@export var model: Node3D
@export var b_lich: bool = false
@export var health: int = 8
@onready var fov_ray: RayCast3D = $FOVRayCast3D
@onready var death_light: OmniLight3D = $DeathOmniLight3D
@onready var hit_stream: AudioStreamPlayer3D = $HitStreamPlayer3D
@onready var aggro_stream: AudioStreamPlayer3D = $AggroStreamPlayer3D
@onready var attack_stream: AudioStreamPlayer3D = $AttackStreamPlayer3D

const lich_bolt_scene = preload("res://scenes/entities/abilities/lich_bolt.tscn")
const SPEED: float = 3.0
const ATTACK_SPEED: float = 5.5
const TURN_SPEED: float = 0.1
const ATTACK_DAMAGE: int = 2

var attack_timer: Timer = Timer.new()
var bolt_timer: Timer = Timer.new()

var player: CharacterBody3D
var b_has_aggro: bool = false
var b_has_target: bool = false
var b_can_hear: bool = false
var b_can_see: bool = false
var b_has_LOS: bool = false
var b_is_attacking: bool = false
var b_can_attack: bool = true
var b_can_hit: bool = true
var b_under_attack: bool = false
var b_bolt_timer: bool = true
var spawn_id: int = -1
var tar_rot: float = 0.0

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.wait_time = 1.0
	attack_timer.timeout.connect(_on_attack_timeout)
	add_child(bolt_timer)
	bolt_timer.one_shot = true
	bolt_timer.wait_time = 3.0
	bolt_timer.timeout.connect(_on_bolt_timeout)
	
func _physics_process(delta: float) -> void:
	if state_machine.get_current_state() == "EnemyDead":
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player and not player.b_dead:
		if _LOS_player() \
		or (b_can_hear and not player.b_is_sneaking and player.b_is_moving) \
		or b_under_attack:
			aggro_stream.play
			b_has_aggro = true
			b_under_attack = false
			if state_machine.get_current_state() == "EnemyIdle" and not b_lich:
				state_machine.on_change_state(state_machine.current_state, "EnemyChase")
		else:
			b_has_aggro = false
	else:
		b_has_aggro = false
		
	if b_lich and b_has_LOS and b_bolt_timer:
		if global_position.distance_to(player.global_position) <= 20.0:
			_bolt()
	
	var direction: Vector3 = Vector3()
	
	# Find Path to Target
	if b_has_target:
		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
		direction = global_position.direction_to(next_path_pos).normalized()
		tar_rot = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
	elif b_has_aggro:
		var player_dir: Vector3 = global_position.direction_to(player.global_position).normalized()
		tar_rot = player_dir.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)

	# Turn Towards Nav Goal
	rotation.y = lerp_angle(rotation.y, tar_rot, TURN_SPEED)
		
	# Move towards Current Nav Goal
	if direction:
		if b_has_aggro:
			velocity = direction * ATTACK_SPEED
		else:
			velocity = direction * SPEED
		if model:
			model.anim.play("walk", 1.0)
	else:
		if b_has_aggro:
			velocity.x = move_toward(velocity.x, 0, ATTACK_SPEED)
			velocity.z = move_toward(velocity.z, 0, ATTACK_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if model and not b_is_attacking:
			model.anim.play("idle", 1.0)
	
	move_and_slide()

func take_damage(damage_amount: int) -> void:
	if state_machine.get_current_state() != "EnemyDead":
		hit_stream.play()
		b_under_attack = true
		if b_has_aggro:
			health -= damage_amount
		else:
			health -= damage_amount * 4
		if health <= 0:
			state_machine.on_change_state(state_machine.current_state, "EnemyDead")
			if spawn_id > -1:
				Gamestate.remove_spawn(spawn_id)
		#print(health)


func attack() -> void:
	if b_can_attack:
		attack_stream.play()
		b_is_attacking = true
		b_can_attack = false
		b_can_hit = true
		model.anim.play("attack")
		attack_timer.start()
		
func hit_player() -> void:
	b_can_hit = false
	if player:
		player.health_component.on_take_damage(ATTACK_DAMAGE)

func _LOS_player() -> bool:
	if player and b_can_see:
		var end_pos: Vector3 = player.global_position
		fov_ray.target_position = to_local(end_pos)
		if fov_ray.is_colliding():
			if fov_ray.get_collider().is_in_group("Player"):
				b_has_LOS = true
				return true
			else:
				b_has_LOS = false
				return false
		else:
			b_has_LOS = false
			return false
	else:
		b_has_LOS = false
		return false

func _bolt() -> void:
	b_bolt_timer = false
	bolt_timer.start()
	var new_bolt: CharacterBody3D = lich_bolt_scene.instantiate()
	get_tree().get_root().add_child(new_bolt)
	new_bolt.global_position = global_position
	new_bolt.global_position.y += 1.0

func _on_listen_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		b_can_hear = true

func _on_listen_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		b_can_hear = false

func _on_attack_timeout() -> void:
	b_can_attack = true

func _on_bolt_timeout() -> void:
	b_bolt_timer = true
