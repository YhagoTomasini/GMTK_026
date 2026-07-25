extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var fists : Area3D
@onready var sprite_3d: Sprite3D = $fists_area/Sprite3D

func _physics_process(delta: float) -> void:
	## A.
	if not is_on_floor():
		velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#pass
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target = atan2(direction.x, direction.z)
		fists.rotation.y = lerp_angle(fists.rotation.y, target, 10.0*delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("soco"):
		sprite_3d.visible = false
		fists.monitoring = true
		await get_tree().create_timer(0.5).timeout
		sprite_3d.visible = true
		fists.monitoring = false


func _on_fists_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
