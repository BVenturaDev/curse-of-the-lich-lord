extends Control

func _ready():
	if Gamestate.b_first_start:
		get_tree().paused = true
	else:
		visible = false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		visible = false
		get_tree().paused = false
		if Gamestate.b_first_start:
			Gamestate.b_first_start = false
			get_parent().tutorials.toggle_sneak()
