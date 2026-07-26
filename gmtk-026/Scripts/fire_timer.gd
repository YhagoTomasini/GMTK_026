extends Control

@export var timer: Timer
@export var text_number: Label
@export var flame_bar: Sprite2D


func _ready() -> void:
	text_atualization()
	timer.start()
	

func _process(_delta: float) -> void:
	text_atualization()
	if Input.is_action_just_pressed("ui_accept"):
		Globals.temp_left += 2
		
	var shader = flame_bar.material as ShaderMaterial
	shader.set_shader_parameter("size", 2.25 - (Globals.temp_left / 666.0))

func text_atualization():
	text_number.text = str(Globals.temp_left)

func _on_timer_timeout() -> void:
	Globals.temp_left -= 1
