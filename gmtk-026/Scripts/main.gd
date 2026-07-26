extends Node3D

@onready var player: CharacterBody3D = $player

func _ready() -> void:
	Globals.life_player = Globals.save_life_player
	Globals.temp_left = Globals.save_temp_left

func _physics_process(_delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
