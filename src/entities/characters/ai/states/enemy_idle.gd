extends State
class_name EnemyIdle

var timer: Timer = Timer.new()
var character: CharacterBody3D
var player: CharacterBody3D
var b_has_target = false

func _ready() -> void:
	character = get_parent().get_parent()
	player = get_tree().get_nodes_in_group("Player")[0]
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timeout)

func Physics_Update(_delta: float) -> void:
	if character:
		if not b_has_target:
			var char_pos: Vector3 = Vector3()
			if character.b_has_aggro and character.b_lich and player:
				char_pos = player.global_position
			else:
				char_pos = character.global_position
			var r_offset: Vector3 = Vector3(randf_range(-10.0, 10.0), 0.0, randf_range(-10.0, 10.0))
			var tar_pos: Vector3 = char_pos + r_offset
			character.nav_agent.target_position = tar_pos
			character.b_has_target = true
			b_has_target = true
		elif character.nav_agent.is_navigation_finished() and character.b_has_target:
			character.b_has_target = false
			if character.b_lich:
				timer.wait_time = randf_range(1.0, 3.0)
			else:
				timer.wait_time = randf_range(2.0, 10.0)
			timer.start()

func _on_timeout():
	b_has_target = false
