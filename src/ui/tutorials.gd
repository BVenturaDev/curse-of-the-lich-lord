extends Control

@onready var sneak: Label = $Sneak
@onready var health: Label = $Health
@onready var lever: Label = $Lever

var timer: Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 5.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timeout)

func toggle_sneak() -> void:
	_toggle_visible()
	sneak.visible = true
	timer.start()

func toggle_health() -> void:
	_toggle_visible()
	health.visible = true
	timer.start()

func toggle_lever() -> void:
	_toggle_visible()
	lever.visible = true
	timer.start()
func _on_timeout() -> void:
	_toggle_visible()

func _toggle_visible() -> void:
	for child in get_children():
		if child is Label:
			child.visible = false
