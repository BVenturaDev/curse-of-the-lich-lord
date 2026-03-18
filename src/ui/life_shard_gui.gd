extends Control

class_name LifeShardGUI

@onready var shard_1: Sprite2D = $Shard1
@onready var shard_2: Sprite2D = $Shard2
@onready var shard_3: Sprite2D = $Shard3
@onready var shard_4: Sprite2D = $Shard4

var b_hide: bool = false

func hide_shard() -> void:
	b_hide = not b_hide
	if b_hide:
		modulate.a = 0 
	else:
		modulate.a = 1
		
func set_health(hp: int) -> void:
	match hp:
		0:
			shard_1.frame = 4
			shard_2.frame = 5
			shard_3.frame = 6
			shard_4.frame = 7
		1:
			shard_1.frame = 0
			shard_2.frame = 5
			shard_3.frame = 6
			shard_4.frame = 7
		2:
			shard_1.frame = 0
			shard_2.frame = 1
			shard_3.frame = 6
			shard_4.frame = 7
		3:
			shard_1.frame = 0
			shard_2.frame = 1
			shard_3.frame = 2
			shard_4.frame = 7
		4:
			shard_1.frame = 0
			shard_2.frame = 1
			shard_3.frame = 2
			shard_4.frame = 3
