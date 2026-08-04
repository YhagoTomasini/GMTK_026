extends Node3D
@export var damage_fireball : float = 5
@onready var coli = $Area3D/CollisionShape3D

func _ready() -> void:
	#var tween = create_tween()
	#tween.tween_property(coli, "scale", Vector3(6, 6, 6), 0.5)
	$explosion.emitting = true
	await get_tree().create_timer(01).timeout
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		print("dentro")
		body.takeDamage(global_position, damage_fireball)
