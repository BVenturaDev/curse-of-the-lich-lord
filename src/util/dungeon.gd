extends Node3D

const skeleton = preload("res://scenes/entities/characters/ai/skeleton.tscn")

func _ready() -> void:
	for i in range(0, Gamestate.death_positions.size()):
		print(Gamestate.death_positions[i])
