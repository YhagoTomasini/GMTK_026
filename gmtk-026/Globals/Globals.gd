extends Node

var playerRotation : Vector3
var temp_left = 666
var mana_player = 20

var save_temp_left = 666
var save_mana_player = 20

var burning : bool = true

func fuel_lamp(time_gain : float):
	burning = false
	
	var gain = clamp(temp_left+time_gain, 0.0, 666.0)
	var tween = create_tween()
	tween.tween_property(self, "temp_left", gain, 2.0)
	
	await tween.finished
	burning = true
	
func regeneration():
	if mana_player < 20:
		mana_player += 1
