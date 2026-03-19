extends Node3D

@export var gate: Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer

var b_pressed = false

func interact() -> void:
	if not b_pressed:
		b_pressed = true
		anim.play("pressed")
		gate.anim.play("open")
