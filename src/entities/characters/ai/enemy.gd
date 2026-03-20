extends CharacterBody3D
class_name enemy

@export var nav_agent: NavigationAgent3D
@export var state_machine: Node
@export var model: Node3D
@onready var fov_ray: RayCast3D = $FOVRayCast3D
@onready var death_light: OmniLight3D = $DeathOmniLight3D

const SPEED: float = 3.0
const ATTACK_SPEED: float = 5.5
const TURN_SPEED: float = 0.1
const ATTACK_DAMAGE: int = 2

var attack_timer: Timer = Timer.new()

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
var health: int = 8
var spawn_id: int = -1

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.wait_time = 1.0
	attack_timer.timeout.connect(_on_attack_timeout)
	
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
			b_has_aggro = true
			b_under_attack = false
			if state_machine.get_current_state() == "EnemyIdle":
				state_machine.on_change_state(state_machine.current_state, "EnemyChase")
		else:
			b_has_aggro = false
	else:
		b_has_aggro = false
	
	var direction: Vector3 = Vector3()
	# Find Path to Target
	if b_has_target:
		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
		direction = global_position.direction_to(next_path_pos).normalized()
		
		# Turn Towards Nav Goal
		var tar_rot: float = 0.0
		if b_has_LOS:
			var player_dir: Vector3 = global_position.direction_to(player.global_position).normalized()
			tar_rot = player_dir.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		else:
			tar_rot = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
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
		b_under_attack = true
		if b_has_aggro:
			health -= damage_amount
		else:
			health -= damage_amount * 4
		if health <= 0:
			state_machine.on_change_state(state_machine.current_state, "EnemyDead")
			if spawn_id > -1:
				Gamestate.remove_spawn(spawn_id)


func attack() -> void:
	if b_can_attack:
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

func _on_listen_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		b_can_hear = true

func _on_listen_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		b_can_hear = false

func _on_attack_timeout() -> void:
	b_can_attack = true
