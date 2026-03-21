extends Node3D

@onready var levers: Node3D = $Levers
@onready var music: AudioStreamPlayer2D = $MusicAudioStreamPlayer2D

const skeleton = preload("res://scenes/entities/characters/ai/skeleton.tscn")

func _ready() -> void:
	for i in range(0, Gamestate.death_positions.size()):
		var new_skele = skeleton.instantiate()
		add_child(new_skele)
		#new_skele.scale = Vector3(1.25, 1.25, 1.25)
		new_skele.global_position = Gamestate.death_positions[i]
		new_skele.health = Gamestate.death_health[i]
		new_skele.death_light.visible = true
		new_skele.spawn_id = i
	for i in range(0, Gamestate.open_levers.size()):
		levers.get_child(i).interact()

func _on_music_audio_stream_player_2d_finished() -> void:
	music.play()
