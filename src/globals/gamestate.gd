extends Node

var death_positions: Array = []
var death_health: Array = []
var open_levers: Array = []

func reset_game(player: CharacterBody3D):
	death_positions.append(player.global_position)
	death_health.append(player.health_component.max_health)
	get_tree().reload_current_scene()

func remove_spawn(spawn_id: int) -> void:
	death_positions.remove_at(spawn_id)
	death_health.remove_at(spawn_id)
