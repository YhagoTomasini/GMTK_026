extends Node3D

@onready var pivo_spawner: Node3D = $"."
@export var arraysDeEnemys : Array[PackedScene]
@onready var marker_3d: Marker3D = $Marker3D
@onready var timer: Timer = $Timer


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	timer.start()
	await get_tree().create_timer(60).timeout
	timer.wait_time = 1.5
	await get_tree().create_timer(180).timeout
	timer.wait_time = 1
	await get_tree().create_timer(300).timeout
	timer.wait_time = 0.5

func spawn():
	var escolido = arraysDeEnemys.pick_random()
	var enemy_instance = escolido.instantiate()
	add_sibling(enemy_instance)
	enemy_instance.global_position = marker_3d.global_position

func _on_timer_timeout() -> void:
	spawn()
	await get_tree().create_timer(1).timeout
	pivo_spawner.global_rotation = Vector3(0, randf_range(0, TAU), 0)
