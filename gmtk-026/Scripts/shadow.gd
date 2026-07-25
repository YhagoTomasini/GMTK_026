extends Sprite3D

@export var player : CharacterBody3D

func _process(_delta: float) -> void:
	global_position.x = player.global_position.x + 0.06
	global_position.z = player.global_position.z + 0.2
