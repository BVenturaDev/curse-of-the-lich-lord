extends Node3D

@onready var victory_stream: AudioStreamPlayer3D = $VictoryStreamPlayer3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.victory()
		victory_stream.play()
