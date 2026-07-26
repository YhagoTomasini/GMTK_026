extends Control

@export var scroll : ScrollContainer
@export var text_node: RichTextLabel
@export var velo: float = 1.0
@export var pause: Control

var acabou: bool = false

var acelerando : bool

@export var parallax : Array[Parallax2D]
var intensidade = 25.0
var suavidade = 5.0

func _ready() -> void:
	acelerando = false
	acabou = false

func fim():
	acabou = true
	pause.pausar()
	print("fim")

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size
	
	var offset = (mouse_pos - screen_size / 2.0) / (screen_size / 2.0)
	
	for i in parallax.size():
		var fator = (i + 1) / float(parallax.size())
		var alvo = offset * intensidade * fator
		
		parallax[i].scroll_offset = parallax[i].scroll_offset.lerp(alvo, delta * suavidade)
	
	if acabou:
		return
	
	# Controle de velocidade
	if Input.is_action_pressed("ui_accept"):
		if !acelerando:
			acelerando = true
		velo = 6.0
	else:
		if acelerando:
			acelerando = false
		velo = 1.0
	
	if scroll.scroll_vertical <= text_node.size.y + 100:
		# Move créditos
		scroll.scroll_vertical += velo
		
	else:
		fim()
