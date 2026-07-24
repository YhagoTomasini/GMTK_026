extends AnimatedSprite3D

func _ready() -> void:
	pass
	if get_parent().name == "player":
		var cam := get_viewport().get_camera_3d()
		if cam:
			look_at(cam.global_position, Vector3.UP)
			Globals.playerRotation = rotation
	else:
		await get_tree().create_timer(0.1).timeout
		rotation = Globals.playerRotation
		
#func _process(_delta: float) -> void:
	#var cam := get_viewport().get_camera_3d()
	#if cam:
		#look_at(cam.global_position, Vector3.UP)
