extends State
class_name EnemyDead

const life_shard_scene = preload("res://scenes/entities/life_shard.tscn")

var timer: Timer = Timer.new()

func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	
func Enter() -> void:
	get_parent().get_parent().model.ragdoll()
	timer.start()
	
func _on_timeout() -> void:
	var new_shard = life_shard_scene.instantiate()
	get_tree().get_root().add_child(new_shard)
	new_shard.global_position = get_parent().get_parent().global_position
