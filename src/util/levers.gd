extends Node3D

func _ready():
	for i in range(0, get_children().size()):
		get_child(i).lever_id = i
