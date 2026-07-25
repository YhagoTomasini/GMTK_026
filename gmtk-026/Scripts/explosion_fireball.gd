extends Node3D


func _ready() -> void:
	$explosion.emitting = true
	await get_tree().create_timer(0.5).timeout
	queue_free()
