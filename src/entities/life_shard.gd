extends Node3D

var timer: Timer = Timer.new()
var player_body: Node3D


func _ready():
	add_child(timer)
	timer.wait_time = 0.5
	timer.timeout.connect(_on_add_health)
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_body = body
		timer.start()
		
func _on_add_health() -> void:
	player_body.get_node("HealthComponent").on_add_health(4)
	queue_free()
