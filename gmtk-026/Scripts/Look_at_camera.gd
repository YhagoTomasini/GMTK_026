extends AnimatedSprite3D

func _process(_delta: float) -> void:
	var cam := get_viewport().get_camera_3d()
	if cam:
		look_at(cam.global_position, Vector3.UP)
