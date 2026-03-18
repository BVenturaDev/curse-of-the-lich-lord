extends State
class_name EnemyDead

const life_shard_scene = preload("res://scenes/entities/life_shard.tscn")

func Enter() -> void:
	get_parent().get_parent().model.ragdoll()
	var new_shard = life_shard_scene.instantiate()
	get_tree().get_root().add_child(new_shard)
	new_shard.global_position = get_parent().get_parent().global_position
