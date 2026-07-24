extends Camera3D

@export var player : Node3D
@export var velo : float = 4.8

var offset : Vector3

func _ready() -> void:
	offset = global_position - player.global_position
	
func _physics_process(delta: float) -> void:
	if !player:
		return
	
	var destiny = player.global_position + offset
	global_position = global_position.lerp(destiny, velo * delta)
