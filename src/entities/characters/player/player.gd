extends CharacterBody3D

@onready var cam_tilt: Node3D = $CameraTilt
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var attack_area: Area3D = $CameraTilt/Sword/AttackArea3D
@onready var interact_cast: RayCast3D = $CameraTilt/InteractRayCast3D
@onready var interact_text: Control = $InteractText
@onready var death_screen: Control = $DeathScreen
@onready var win_screen: Control = $WinScreen
@onready var health_component: HealthComponent = $HealthComponent

const SPEED: float = 5.0
const SNEAK_SPEED: float = 2.5
const JUMP_VELOCITY: float = 4.5
const MOUSE_SPEED: float = 0.002

var attack_damage: int = 2
var b_is_sneaking: bool = false
var b_is_moving: bool = false
var b_attacking: bool = false
var b_can_hit: bool = true
var b_dead: bool = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x * MOUSE_SPEED
		cam_tilt.rotation.x -= event.relative.y * MOUSE_SPEED
		#print(cam_tilt.rotation.x / PI)
		cam_tilt.rotation.x = clamp(cam_tilt.rotation.x, -0.3 * PI, 0.3 * PI)
		cam_tilt.rotation.z = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if b_dead:
		velocity = Vector3()
		move_and_slide()
		death_screen.visible = true
		interact_text.visible = false
		if Input.is_action_pressed("ui_accept"):
			Gamestate.reset_game(self)
		return
		
	if _can_interact():
		interact_text.visible = true
	else:
		interact_text.visible = false
	
	if Input.is_action_pressed("interact"):
		_interact_cast()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("attack") and not b_attacking:
		anim.play("attack")
		b_attacking = true
		b_can_hit = true
	elif b_attacking and b_can_hit and attack_area.has_overlapping_bodies():
		var bodies: Array = attack_area.get_overlapping_bodies()
		for body in bodies:
			if body.is_in_group("Enemy"):
				b_can_hit = false
				body.take_damage(attack_damage)
		
	
	if Input.is_action_just_pressed("sneak"):
		if b_is_sneaking:
			b_is_sneaking = false
			cam_tilt.position.y = 1.5
		else:
			b_is_sneaking = true
			cam_tilt.position.y = 1.0

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if b_is_sneaking:
			velocity.x = direction.x * SNEAK_SPEED
			velocity.z = direction.z * SNEAK_SPEED
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if velocity.x == 0 and velocity.z == 0:
		b_is_moving = false
	else:
		b_is_moving = true

	move_and_slide()

func victory() -> void:
	win_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _can_interact() -> bool:
	if interact_cast.is_colliding():
		var body: Node3D = interact_cast.get_collider().get_parent().get_parent()
		if not body.b_pressed:
			return true
	return false

func _interact_cast() -> void:
	if interact_cast.is_colliding():
		var body: Node3D = interact_cast.get_collider().get_parent().get_parent()
		if body.is_in_group("Interact"):
			body.interact()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		b_attacking = false
