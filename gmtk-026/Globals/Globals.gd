extends Node

var playerRotation : Vector3
var temp_left = 666
var life_player: int = 20

var save_temp_left = 666
var save_life_player = 20

func _ready() -> void:
	pass
	
func regeneration():
	if life_player < 20:
		life_player += 1
