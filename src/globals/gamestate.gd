extends Node

var death_positions: Array = []
var death_health: Array = []
var open_levers: Array = []

var b_first_start: bool = true
var b_first_health: bool = true
var b_first_lever: bool = true

func reset_game(player: CharacterBody3D):
	death_positions.append(player.global_position)
	death_health.append(player.health_component.max_health / 2)
	get_tree().reload_current_scene()

func remove_spawn(spawn_id: int) -> void:
	death_positions.remove_at(spawn_id)
	death_health.remove_at(spawn_id)
	
func open_lever(lever_id):
	if not open_levers.has(lever_id):
		open_levers.append(lever_id)
