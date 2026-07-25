extends Area3D

@export var speed : float = -5
@onready var explosion: GPUParticles3D = $explosion

func _physics_process(delta: float) -> void:
	var foward_direction = global_transform.basis.z.normalized()
	global_translate(foward_direction * speed * delta)
	await get_tree().create_timer(0.3).timeout
	queue_free()



func _on_fire_trial_finished() -> void:
	explosion.emitting = true
	
