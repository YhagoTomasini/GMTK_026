extends Control

@export var voltarB : Button
@export var corFundo : ColorRect
@export var configs : Control

var parado : bool
var naConfig : bool

var usando_teclado : bool 

func _ready() -> void:
	visible = false
	parado = false
	naConfig = false
	corFundo.color = Color(0.58, 0.0, 0.188, 0.486)
	
	usando_teclado = false

func despausa():
	get_tree().paused = false
	
	visible = false
	parado = false
	
func pausar():
	if !parado:
		visible = true
		get_tree().paused = true
		
		await get_tree().process_frame
		parado = true

func grabFocus():
	naConfig = false
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		if !parado:
			if !naConfig:
				pausar()
		else:
			if !naConfig:
				despausa()

	# 🎮 detecta teclado / controle
	if visible:
		if event.is_action_pressed("ui_up") \
		or event.is_action_pressed("ui_down") \
		or event.is_action_pressed("ui_left") \
		or event.is_action_pressed("ui_right"):

			if not usando_teclado:
				usando_teclado = true

				# se ninguém estiver focado, foca o primeiro botão
			if not get_viewport().gui_get_focus_owner():
				voltarB.grab_focus()

		# 🖱 detecta movimento do mouse
		if event is InputEventMouseMotion:
			if usando_teclado:
				usando_teclado = false

				var foco = get_viewport().gui_get_focus_owner()
				if foco:
					foco.release_focus()


func _on_b_reiniciar_pressed() -> void:
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_b_som_pressed() -> void:
	pass # Replace with function body.


func _on_b_menu_pressed() -> void:
	get_tree().paused = false
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_b_voltar_pressed() -> void:
	despausa()
