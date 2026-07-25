extends Control

@onready var timer: Timer = $Timer
@onready var text_number: Label = $text_number


func _ready() -> void:
	text_atualization()
	timer.start()
	

func _process(_delta: float) -> void:
	text_atualization()
	if Input.is_action_just_pressed("ui_accept"):
		Globals.temp_left += 1

func text_atualization():
	text_number.text = str(Globals.temp_left)

func _on_timer_timeout() -> void:
	Globals.temp_left -= 1
