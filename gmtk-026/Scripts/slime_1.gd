extends CharacterBody3D

@export var anim : AnimatedSprite3D
@onready var nav_agent: NavigationAgent3D = $nav_agent
#@export var collision : CollisionShape3D

@export var SPEED = 3.0
@export var life_enemy = 2.0
@export var damage_enemy = 1
@export var atack_range : float = 2 
@export var time_gain : float = 2 * 4
@export var player_life_regain : float = 1

@onready var hit_box: Area3D = $hit_box
@onready var hitbox_colision: CollisionShape3D = $hit_box/hitbox_colision

var is_attacking: bool = false
var following : bool = true

func _ready() -> void:
	anim.frame = randi_range(0, 3)
	
func _physics_process(_delta: float) -> void:
	if !following:
		return
	
	var current_location = global_transform.origin
	var next_location =  nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)
	
	if global_position.x < next_location.x:
		anim.sorting_offset = -4
	elif global_position.x > next_location.x:
		anim.sorting_offset = 4
	
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
	
	target_in_range()

func update_target_location(target_location):
	if following:
		nav_agent.target_position = target_location
	
func takeDamage(pPosi : Vector3, damage : float) -> void:
	life_enemy -= damage
	following = false
	collision_mask = 24
	anim.modulate = Color(2.5, 0.0, 0.0, 1.0)
	knockback(pPosi)
	if life_enemy > 0:
		collision_mask = 3
		await get_tree().create_timer(.8).timeout
# retirando o following o bixo n para de correr atrás de você entretanto ele n te persegue depois de morto
		following = true
		anim.modulate = Color(2.5, 2.5, 2.5, 1.0)
		#animação de hurt <-----------
	else:
		anim.play("dying")
		await anim.animation_finished
		Globals.temp_left += time_gain
		Globals.life_player += 1
		queue_free()

func knockback(pPosi : Vector3):
	var knockbackD = (global_position - pPosi).normalized()
	var tween = create_tween()
	tween.tween_property(
		self, "global_position", global_position + knockbackD *2, 0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func target_in_range() -> void:
	if is_attacking:
		return 
	var target_pos = nav_agent.target_position
	if global_position.distance_to(target_pos) < atack_range:
		execute_attack()

func execute_attack() -> void:
	is_attacking = true
	hitbox_colision.disabled = false
	await get_tree().create_timer(0.15).timeout
	hitbox_colision.disabled = true
	await get_tree().create_timer(0.8).timeout
	is_attacking = false

func _on_nav_agent_target_reached() -> void:
	pass # Replace with function body.

func _on_nav_agent_velocity_computed(safe_velocity: Vector3) -> void:
	if !following:
		return
		
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


func _on_hit_box_body_entered(body: Node3D) -> void:
	print("teste")
	if body.is_in_group("player"):
		print("batendo no player")
		body.player_take_damage(damage_enemy)
