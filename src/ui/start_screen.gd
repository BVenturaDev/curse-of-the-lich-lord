extends Control

func _ready():
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		visible = false
		get_tree().paused = false
		if Gamestate.b_first_start:
			Gamestate.b_first_start = false
			get_parent().tutorials.toggle_sneak()
