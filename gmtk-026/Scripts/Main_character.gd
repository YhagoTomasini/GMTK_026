extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var cam : Camera3D
@export var anim : AnimatedSprite3D
@export var lamp : Sprite3D
@export var light : OmniLight3D
#ataques melees
@export var fists : Area3D
@export var fistsAnim: AnimatedSprite3D
var canPunch : bool = true
var switch = 1
#ataques magicos
@onready var spells_marker: Marker3D = $spells_marker
@onready var ray_fireball: RayCast3D = $spells_marker/ray_fireball
@export var fireball_scene : PackedScene
var canSpell : bool = true

enum faces {
	DOWN,
	UP,
	LEFT,
	RIGHT
}

var facing := faces.DOWN

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
	var direction  := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target = atan2(direction.x, direction.z)
		fists.rotation.y = lerp_angle(fists.rotation.y, target, 10.0*delta)
		
		if velocity.z < 0:
			facing = faces.UP
			anim.play("idle_back")
			lamp.sorting_offset = -2.0
			light.position.z = lerp(light.position.z, -0.4, 1*delta)
			
		else:
			facing = faces.DOWN
			anim.play("idle_front")
			lamp.sorting_offset = 2.0
			light.position.z = lerp(light.position.z, 0.4, 1*delta)
			
		if velocity.x < 0:
			facing = faces.LEFT
			anim.flip_h = true
			lamp.flip_h = true
			light.position.x = lerp(light.position.x, 0.75, 1*delta)

		elif velocity.x > 0:
			facing = faces.RIGHT
			anim.flip_h = false
			lamp.flip_h = false
			light.position.x = lerp(light.position.x, -0.75, 1*delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
func _process(_delta: float) -> void:
	look_at_cursor()

func _input(event: InputEvent) -> void:		
	if event.is_action_pressed("soco"):
		punch()
	if event.is_action_pressed("magic"):
		magic()

func look_at_cursor():
	var target_plane_mouse = Plane(Vector3(0,1,0), position.y)
	var ray_leght = 2000
	var mouse_position = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(mouse_position)
	var to = from + cam.project_ray_normal(mouse_position) * ray_leght
	var cursor_position_on_place = target_plane_mouse.intersects_ray(from, to)
	
	if cursor_position_on_place != null:
		$spells_marker.look_at(cursor_position_on_place,Vector3.UP,0)

func punch():
	if canPunch: 
		canPunch = false
		
		switch *= -1
		fistsAnim.visible = true
		fists.monitoring = true
		
		match facing:
			faces.DOWN:
				fistsAnim.sorting_offset = 3
				if switch > 0:
					fistsAnim.flip_h = true
				else:
					fistsAnim.flip_h = false
				fistsAnim.play("punch_down")
				
			faces.UP:
				fistsAnim.sorting_offset = -3
				if switch > 0:
					fistsAnim.flip_h = true
				else:
					fistsAnim.flip_h = false
				fistsAnim.play("punch_up")
				
			faces.LEFT:
				if switch > 0:
					fistsAnim.sorting_offset = 3
					fistsAnim.flip_h = true
					fistsAnim.play("punch_down")
				else:
					fistsAnim.sorting_offset = -3
					fistsAnim.flip_h = true
					fistsAnim.play("punch_up")
			faces.RIGHT:
				if switch > 0:
					fistsAnim.sorting_offset = 3
					fistsAnim.flip_h = false
					fistsAnim.play("punch_down")
				else:
					fistsAnim.sorting_offset = -3
					fistsAnim.flip_h = false
					fistsAnim.play("punch_up")
				
		await fistsAnim.animation_finished
		fistsAnim.visible = false
		fists.monitoring = false
		
		canPunch = true
	
func magic():
	var fireball_instanciate = fireball_scene.instantiate()
	fireball_instanciate.global_transform = $spells_marker.global_transform
	add_sibling(fireball_instanciate)
	#await get_tree().create_timer(0.25).timeout
	#if ray_fireball.is_colliding():
		#ray_fireball.get_collider().takeDamage()
	#await get_tree().create_timer(0.25).timeout

func _on_fists_area_body_entered(body: Node3D) -> void:
	body.takeDamage()
