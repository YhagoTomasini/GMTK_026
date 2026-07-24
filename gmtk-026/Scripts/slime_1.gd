extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $nav_agent

var SPEED = 3.0

func _physics_process(_delta: float) -> void:
	var current_location = global_transform.origin
	var next_location =  nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)
	
func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func _on_nav_agent_target_reached() -> void:
	pass # Replace with function body.


func _on_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
