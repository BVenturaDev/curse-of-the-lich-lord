extends CharacterBody3D

@export var nav_agent: NavigationAgent3D
@export var state_machine: Node
@export var model: Node3D

const SPEED: float = 3.0
const TURN_SPEED: float = 0.1

var player: CharacterBody3D
var b_has_aggro: bool = false
var b_has_target: bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction: Vector3 = Vector3()
	#if b_has_target and player:
	#	if global_position.distance_to(player.global_position) >= 1.5:
	#		nav_agent.target_position = player.global_position
	#		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	#		direction = global_position.direction_to(next_path_pos).normalized()
	
	# Find Path to Target
	if b_has_target:
		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
		direction = global_position.direction_to(next_path_pos).normalized()
		# Turn Towards Nav Goal
		var tar_rot: float = direction.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		rotation.y = lerp_angle(rotation.y, tar_rot, TURN_SPEED)
		
	# Move towards Current Nav Goal
	if direction:
		velocity = direction * SPEED
		if model:
			model.anim.play("walk", 1.0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if model:
			model.anim.play("idle", 1.0)
	
	move_and_slide()
