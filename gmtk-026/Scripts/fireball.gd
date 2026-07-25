extends Area3D

@export var speed : float = -5
@export var explosion_fire_scene : PackedScene

func _physics_process(delta: float) -> void:
	var foward_direction = global_transform.basis.z.normalized()
	global_translate(foward_direction * speed * delta)
	await get_tree().create_timer(0.3).timeout
	explosion_particles()
	queue_free()

func explosion_particles():
	var explosion_fire_instanciate = explosion_fire_scene.instantiate()
	explosion_fire_instanciate.global_transform = global_transform
	add_sibling(explosion_fire_instanciate)
	

func _on_body_entered(body: Node3D) -> void:
	explosion_particles()
	body.takeDamage()
