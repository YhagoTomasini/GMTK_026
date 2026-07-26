extends Control

@export var scroll : ScrollContainer
@export var text_node: RichTextLabel
@export var velo: float = 1.0
@export var pause: Control

var acabou: bool = false

var acelerando : bool

func _ready() -> void:
	acelerando = false
	acabou = false

func fim():
	acabou = true
	pause.pausar()
	print("fim")

func _process(delta: float) -> void:
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
