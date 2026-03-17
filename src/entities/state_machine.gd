extends Node

@export var init_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.ChangeState.connect(on_change_state)
	if init_state:
		init_state.Enter()
		current_state = init_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_change_state(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		state.Exit()
	
	new_state.Enter()
	current_state = new_state

func get_current_state() -> String:
	return current_state.name
