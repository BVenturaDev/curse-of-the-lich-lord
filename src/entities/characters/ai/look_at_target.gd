extends Node3D

@export var look_tar: Marker3D
@export var anim: AnimationPlayer

var start_pos: Vector3 = Vector3()

func _ready():
	start_pos = look_tar.position

func _process(_delta: float) -> void:
	if get_parent().b_has_aggro and get_parent().player:
		look_tar.global_position = get_parent().player.global_position
		look_tar.global_position.y += 1.5
	else:
		look_tar.position = start_pos

func _on_fov_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_parent().b_can_see = true

func _on_fov_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_parent().b_can_see = false


func _on_hand_area_3d_body_entered(body: Node3D) -> void:
	if get_parent().b_is_attacking and get_parent().b_can_hit and body.is_in_group("Player"):
		get_parent().hit_player()
