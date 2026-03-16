extends CharacterBody3D

@export var nav_agent: NavigationAgent3D
@export var state_machine: Node
@export var model: Node3D

const SPEED: float = 3.0
const TURN_SPEED: float = 0.1

var player: CharacterBody3D
var b_has_aggro: bool = false
var b_has_target: bool = false
var b_can_hear: bool = false
var b_can_see: bool = false
var b_has_LOS: bool = false

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	
	#if b_has_target and player:
	#	if global_position.distance_to(player.global_position) >= 1.5:
	#		nav_agent.target_position = player.global_position
	#		var next_path_pos: Vector3 = nav_agent.get_next_path_position()
	#		direction = global_position.direction_to(next_path_pos).normalized()
	
	if player:
		if b_can_hear and not player.b_is_sneaking \
		or _LOS_player():
			b_has_aggro = true
	
	var direction: Vector3 = Vector3()
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

func _LOS_player() -> bool:
	if player and b_can_see:
		var start_pos: Vector3 = global_position
		start_pos.y += 1.5
		var end_pos: Vector3 = player.global_position
		end_pos.y += 1.5
		var raycast: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(start_pos, end_pos)
		#raycast.add_exception(self)
		var collision = get_world_3d().direct_space_state.intersect_ray(raycast)
		if collision:
			if collision.collider.is_in_group("Player"):
				print("I SEE YOU!")
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
