extends Control
@export var parallax : Array[Parallax2D]
@export var bPlay : Button

var usando_teclado = false

var intensidade = 25.0
var suavidade = 5.0
#var alvo = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up") \
	or event.is_action_pressed("ui_down") \
	or event.is_action_pressed("ui_left") \
	or event.is_action_pressed("ui_right"):

		if not usando_teclado:
			usando_teclado = true
			
		if not get_viewport().gui_get_focus_owner():
			bPlay.grab_focus()
			
	if event is InputEventMouseMotion:
		if usando_teclado:
			usando_teclado = false

			var foco = get_viewport().gui_get_focus_owner()
			if foco:
				foco.release_focus()

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size
	
	var offset = (mouse_pos - screen_size / 2.0) / (screen_size / 2.0)
	
	for i in parallax.size():
		var fator = (i + 1) / float(parallax.size())
		var alvo = offset * intensidade * fator
		
		parallax[i].scroll_offset = parallax[i].scroll_offset.lerp(alvo, delta * suavidade)
	
func _on_b_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_b_options_pressed() -> void:
	pass # Replace with function body.


func _on_b_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_b_quit_pressed() -> void:
	get_tree().quit()
