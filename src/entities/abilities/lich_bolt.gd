extends CharacterBody3D

@onready var bolt_stream: AudioStreamPlayer3D = $BoltStreamPlayer
@onready var bolt_impact_stream: AudioStreamPlayer3D = $BoltImpactStreamPlayer


const SPEED: float = 8.0
const DAMAGE: int = 4.0

var direction: Vector3 = Vector3()
var tar_pos: Vector3 = Vector3()
var player: Node3D
var b_first_tick: bool = true

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	bolt_stream.play()
	

func _physics_process(delta: float) -> void:
	if player and b_first_tick:
		b_first_tick = false
		tar_pos = player.global_position
		tar_pos.y += 1.25
		direction = global_position.direction_to(tar_pos).normalized()
	velocity = direction * SPEED
	
	move_and_slide()
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.health_component.on_take_damage(DAMAGE)
	if body.is_in_group("Enemy"):
		return
	bolt_impact_stream.play()

func _on_bolt_impact_stream_player_finished() -> void:
	queue_free()
