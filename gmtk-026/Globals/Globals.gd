extends Node

var playerRotation : Vector3
var temp_left = 666
var life_player: int = 20

func _ready() -> void:
	pass
	
func regeneration():
	if life_player < 20:
		life_player += 1
