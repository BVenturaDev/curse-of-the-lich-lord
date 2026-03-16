extends CharacterBody3D

@onready var cam_tilt: Node3D = $CameraTilt

const SPEED: float = 5.0
const SNEAK_SPEED: float = 2.5
const JUMP_VELOCITY: float = 4.5
const MOUSE_SPEED: float = 0.002

var b_is_sneaking: bool = false

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("sneak"):
		if b_is_sneaking:
			b_is_sneaking = false
			cam_tilt.position.y = 1.5
		else:
			b_is_sneaking = true
			cam_tilt.position.y = 1.0
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

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

	move_and_slide()
