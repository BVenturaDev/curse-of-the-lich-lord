extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.get_node("HealthComponent").on_add_health(4)
		queue_free()
