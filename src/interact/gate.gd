extends Node3D

@onready var gate_stream: AudioStreamPlayer3D = $GateStreamPlayer3D
@onready var anim: AnimationPlayer = $AnimationPlayer
#@export var nav: NavigationRegion3D


#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
#	if anim_name == "open":
#		nav.bake_navigation_mesh()
