extends Node
class_name HealthComponent

@export var healthbar: Healthbar
@export var default_health: int = 8

var current_health: int
var max_health: int

const ROT_TIME: float = 10.0

var rot_timer: Timer = Timer.new()

func _ready() -> void:
	current_health = default_health
	max_health = default_health
	healthbar.set_max_health(default_health)
	add_child(rot_timer)
	rot_timer.wait_time = ROT_TIME
	rot_timer.timeout.connect(_on_rot_timeout)
	rot_timer.start()
	
func on_take_damage(dmg_amount: int) -> void:
	if not get_parent().b_dead:
		current_health -= dmg_amount
		if current_health <= 0:
			current_health = 0
			get_parent().b_dead = true
		healthbar.set_health(max_health - current_health)

func on_add_health(health_amount: int) -> void:
	current_health += health_amount
	max_health += health_amount
	if max_health + health_amount > 40:
		max_health = 40
	if current_health + health_amount > 40:
		current_health = 40
	healthbar.set_max_health(max_health)
	healthbar.set_health(max_health - current_health)

func _on_rot_timeout():
	if get_parent().b_started:
		on_take_damage(1)
		rot_timer.start()
