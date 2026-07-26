extends Node

var playerRotation : Vector3
var temp_left = 666
var life_player: float = 20

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	regeneration()
	

func regeneration():
	if life_player < 20:
		life_player += 1
