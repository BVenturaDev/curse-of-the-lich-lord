extends Control

@onready var h_slider: HSlider = $PauseBox/BoxContainer/VBoxContainer/HSlider

#func _ready() -> void:
	#h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			visible = true
			get_tree().paused = true
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			_unpause()

func _unpause() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	get_tree().paused = false


func _on_resume_button_pressed() -> void:
	_unpause()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_h_slider_value_changed(value: float) -> void:
	#print(value)
	AudioServer.set_bus_volume_db(0, value - 50.0)


func _on_restart_button_pressed() -> void:
	_unpause()
	Gamestate.full_reset()
