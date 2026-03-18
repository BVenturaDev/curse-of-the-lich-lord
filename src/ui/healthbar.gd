extends Control
class_name Healthbar

@onready var h_box: HBoxContainer = $BoxContainer/HBoxContainer

const life_shard_scene = preload("res://scenes/ui/life_shard_gui.tscn")

func set_max_health(max_health: int) -> void:
	var shards: int = int(max_health / 4)
	if max_health % 4 > 0:
		shards += 1
	for i in range(0, shards - h_box.get_child_count()):
		var new_shard = life_shard_scene.instantiate()
		h_box.add_child(new_shard)

func set_health(missing_health: int) -> void:
	for life_shard in h_box.get_children():
			life_shard.set_health(4)
	if missing_health > 0:
		var dead_shards: int = int(missing_health / 4)
		var remaining_shards: int = missing_health % 4
		for i in range(h_box.get_child_count() - 1, -1, -1):
			if dead_shards > 0:
				dead_shards -= 1
				h_box.get_child(i).set_health(0)
			elif remaining_shards > 0:
				h_box.get_child(i).set_health(4 - remaining_shards)
				remaining_shards = 0
				return
