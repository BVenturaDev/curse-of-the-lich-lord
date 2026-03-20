extends State
class_name EnemyChase

var player: CharacterBody3D
var character: CharacterBody3D
var last_known_pos: Vector3 = Vector3()

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	character = get_parent().get_parent()

func Enter() -> void:
	if player:
		last_known_pos = player.global_position

func Physics_Update(_delta: float) -> void:
	if character.b_has_LOS:
		last_known_pos = player.global_position
		character.nav_agent.target_position = last_known_pos
		character.b_has_target = true
	elif not character.b_has_target:
		character.nav_agent.target_position = last_known_pos
		character.b_has_target = true
	if character.nav_agent.is_navigation_finished() and character.b_has_target:
		character.b_has_target = false
		if character.global_position.distance_to(player.global_position) <= 2.0:
			character.state_machine.on_change_state(character.state_machine.current_state, "EnemyAttack")
		elif not character.b_has_LOS:
			character.state_machine.on_change_state(character.state_machine.current_state, "EnemyIdle")
