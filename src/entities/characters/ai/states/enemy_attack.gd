extends State
class_name EnemyAttack

var character: CharacterBody3D
var player: CharacterBody3D

func _ready():
	character = get_parent().get_parent()
	player = get_tree().get_nodes_in_group("Player")[0]

func Physics_Update(_delta: float) -> void:
	if character and not player.b_dead:
		if character.global_position.distance_to(player.global_position) <= 1.5:
			character.state_machine.on_change_state(character.state_machine.current_state, "EnemyIdle")
		if character.b_is_attacking:
			if !character.model.anim.is_playing() or character.model.anim.current_animation != "attack":
				character.attack()
		else:
			character.attack()
	else:
		character.state_machine.on_change_state(character.state_machine.current_state, "EnemyIdle")
