extends CharacterBody3D

@onready var hurtbox_colision: CollisionShape3D = $hurt_box/hurtbox_colision
@onready var lamparina: OmniLight3D = $lamparina

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var cam : Camera3D
@export var anim : AnimatedSprite3D
@export var lamp : Sprite3D
@export var light : OmniLight3D


#ataques melees
@export var fists : Area3D
@export var fistsAnim : AnimatedSprite3D
@export var punchCooldown : Timer
var switchPunch = 1
var punchCount = 0
@export var damage : int = 1
@export var fireball_cust : float = 16

#ataques magicos
@onready var spells_marker: Marker3D = $spells_marker
@onready var ray_fireball: RayCast3D = $spells_marker/ray_fireball
@export var spellCooldown : Timer
@export var fireball_scene : PackedScene

enum faces {
	DOWN,
	UP,
	LEFT,
	RIGHT
}
var facing := faces.DOWN

enum states {
	IDLE,
	PUNCHING,
	CASTING
}
var state := states.IDLE

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
	light_force()
	if Globals.temp_left < 0:
		morte()

func _input(event: InputEvent) -> void:		
	if event.is_action_pressed("soco"):
		punch()
	if event.is_action_pressed("magic"):
		magic()


func light_force():

	var max_temp_left: float = 666

	var omni_range: float = 2.4
	var percentage_range = clamp(Globals.temp_left / max_temp_left, 0.6, 1.0)
	lamparina.omni_range = omni_range * percentage_range
	
	var light_energy: float = 0.9
	var percentage_energy = clamp(Globals.temp_left / max_temp_left, 0, 1.0)
	lamparina.light_energy = omni_range * percentage_energy

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
	if state == states.IDLE and punchCount < 2:
		state = states.PUNCHING
		
		punchCount += 1
		switchPunch *= -1
		
		fistsAnim.visible = true
		fists.monitoring = true
		
		punchCooldown.start()
		
		match facing:
			faces.DOWN:
				fistsAnim.sorting_offset = 3
				if switchPunch > 0:
					fistsAnim.flip_h = true
				else:
					fistsAnim.flip_h = false
				fistsAnim.play("punch_down")
				
			faces.UP:
				fistsAnim.sorting_offset = -3
				if switchPunch > 0:
					fistsAnim.flip_h = true
				else:
					fistsAnim.flip_h = false
				fistsAnim.play("punch_up")
				
			faces.LEFT:
				if switchPunch > 0:
					fistsAnim.sorting_offset = 3
					fistsAnim.flip_h = true
					fistsAnim.play("punch_down")
				else:
					fistsAnim.sorting_offset = -3
					fistsAnim.flip_h = true
					fistsAnim.play("punch_up")
			faces.RIGHT:
				if switchPunch > 0:
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
		
		if punchCount >= 2:
			punchCooldown.wait_time = 1.2
			punchCooldown.start()
			
		state = states.IDLE
	
func magic():
	if state == states.IDLE and spellCooldown.is_stopped():
		Globals.temp_left -= fireball_cust
		state = states.CASTING
		spellCooldown.start()
		
		var fireball_instanciate = fireball_scene.instantiate()
		fireball_instanciate.global_transform = $spells_marker.global_transform
		add_sibling(fireball_instanciate)
		
		state = states.IDLE
		
	#if ray_fireball.is_colliding():
		#ray_fireball.get_collider().takeDamage()
	#await get_tree().create_timer(0.25).timeout


func morte():
	get_tree().change_scene_to_file("res://Scenes/defeat_screen.tscn")


func _on_fists_area_body_entered(body: Node3D) -> void:
	body.takeDamage(global_position, damage)

func player_take_damage(dano:int):
	hurtbox_colision.set_deferred("disabled", true)
	Globals.life_player -= dano
	print(Globals.life_player)
	await get_tree().create_timer(1).timeout
	if is_instance_valid(self):
		hurtbox_colision.set_deferred("disabled", false)
	if Globals.life_player <= 0:
		morte()



func _on_cool_down_punch_timeout() -> void:
	punchCount = 0
	punchCooldown.wait_time = 1
