extends Node

var death_positions: Array = []
var death_health: Array = []

func reset_game(player: CharacterBody3D):
	death_positions.append(player.global_position)
	death_health.append(player.health_component.max_health)
	get_tree().reload_current_scene()
