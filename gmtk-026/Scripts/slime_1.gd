extends CharacterBody3D
@export var anim : AnimatedSprite3D
@onready var nav_agent: NavigationAgent3D = $nav_agent

var SPEED = 3.0
var following : bool = true

func _ready() -> void:
	anim.frame = randi_range(0, 3)
	
func _physics_process(_delta: float) -> void:
	var current_location = global_transform.origin
	var next_location =  nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)
	
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
	
func update_target_location(target_location):
	if following:
		nav_agent.target_position = target_location
	
func takeDamage() -> void:
	following = false
	anim.play("dying")
	
	await anim.animation_finished
	queue_free()
	
func _on_nav_agent_target_reached() -> void:
	pass # Replace with function body.


func _on_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
