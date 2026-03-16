extends Node3D

@export var look_tar: Marker3D

var start_pos: Vector3 = Vector3()

func _ready():
	start_pos = look_tar.position

func _process(_delta: float) -> void:
	if get_parent().b_has_target and get_parent().player:
		look_tar.global_position = get_parent().player.global_position
		look_tar.global_position.y += 1.5
	else:
		look_tar.position = start_pos
