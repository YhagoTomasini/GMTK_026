extends Node2D

var registroSons : Dictionary = {}

var sonsAtivos : Dictionary = {}

var pitchOriginal : Dictionary = {}
var volOriginal : Dictionary = {}

@export var sons : Array[SoundEffect]

func _ready() -> void:
	for sons : SoundEffect in sons:
		registroSons[sons.tipo] = sons

func criar_aud_localizado(local : Vector3, tipo : SoundEffect.TIPO_DE_SOM):
	if registroSons.has(tipo):
		var som : SoundEffect = registroSons[tipo]
		if som.tem_limite():
			som.contar_aud(1)
			var novo_aud : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
			add_child(novo_aud)
			
			novo_aud.bus = som.bus
			novo_aud.global_position = local
			novo_aud.stream = som.som
			novo_aud.volume_db = som.volume
			novo_aud.pitch_scale = som.pitch
			novo_aud.pitch_scale += randf_range(-som.pitch_rand, som.pitch_rand)
			
			novo_aud.finished.connect(som.quando_som_acabar)
			novo_aud.finished.connect(novo_aud.queue_free)
			
			novo_aud.play()
			
			if !sonsAtivos.has(tipo):
				sonsAtivos[tipo] = []
			sonsAtivos[tipo].append(novo_aud)
			
			pitchOriginal[tipo] = novo_aud.pitch_scale
			volOriginal[tipo] = novo_aud.volume_db
	else:
		push_error("n foi o audio", tipo)

func criar_aud(tipo : SoundEffect.TIPO_DE_SOM):
	if registroSons.has(tipo):
		var som : SoundEffect = registroSons[tipo]
		if som.tem_limite():
			som.contar_aud(1)
			var novo_aud : AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(novo_aud)
			
			novo_aud.bus = som.bus
			novo_aud.stream = som.som
			novo_aud.volume_db = som.volume
			novo_aud.pitch_scale = som.pitch
			novo_aud.pitch_scale += randf_range(-som.pitch_rand, som.pitch_rand)
			
			novo_aud.finished.connect(som.quando_som_acabar)
			novo_aud.finished.connect(novo_aud.queue_free)
			
			novo_aud.play()
			
			if !sonsAtivos.has(tipo):
				sonsAtivos[tipo] = []
			sonsAtivos[tipo].append(novo_aud)
			
			pitchOriginal[tipo] = novo_aud.pitch_scale
			volOriginal[tipo] = novo_aud.volume_db
	else:
		push_error("n foi o audio", tipo)

func destruir_novo_aud(tipo : SoundEffect.TIPO_DE_SOM):
	if sonsAtivos.has(tipo):
		var som = sonsAtivos[tipo].pop_back()
		var controleLimite : SoundEffect = registroSons[tipo]
		
		if is_instance_valid(som):
			var tween = create_tween()
			tween.tween_property(som, "volume_db", -40, 0.3)
			tween.tween_callback(func():
				som.stop()
				controleLimite.contar_aud(-1)
				som.queue_free()
			)
			
			sonsAtivos.erase(tipo)
			pitchOriginal.erase(tipo)
			volOriginal.erase(tipo)
		
func pitch_tema(opcao : int, tipo : SoundEffect.TIPO_DE_SOM):
	if sonsAtivos.has(tipo) and pitchOriginal.has(tipo):
		for temaAtivo in sonsAtivos[tipo]:
			if is_instance_valid(temaAtivo):
				var pitch_base = pitchOriginal[tipo]
				var tween = create_tween()
				
				if opcao == 1:
					tween.tween_property(temaAtivo, "pitch_scale", pitch_base, 0.5)
				elif opcao == 2:
					tween.tween_property(temaAtivo, "pitch_scale", pitch_base / 2.0, 0.5)
				elif opcao == 3:
					tween.tween_property(temaAtivo, "pitch_scale", pitch_base * 1.5, 0.5)

func vol_som(opcao : int, tipo : SoundEffect.TIPO_DE_SOM):
	if sonsAtivos.has(tipo) and volOriginal.has(tipo):
		for somAtivo in sonsAtivos[tipo]:
			if is_instance_valid(somAtivo):
				var vol_base = volOriginal[tipo]
				var tween = create_tween()
				
				if opcao == 1:
					tween.tween_property(somAtivo, "volume_db", vol_base, 0.5)
				elif opcao == 2:
					tween.tween_property(somAtivo, "volume_db", vol_base - 18.0, 0.5)
				elif opcao == 3:
					tween.tween_property(somAtivo, "volume_db", vol_base + 6.0, 0.5)
			
func destruir_todos_aud(tipo : SoundEffect.TIPO_DE_SOM):
	if sonsAtivos.has(tipo):
		var controleLimite : SoundEffect = registroSons[tipo]
		
		for som in sonsAtivos[tipo]:
			if is_instance_valid(som):
				var tween = create_tween()
				
				tween.tween_property(som, "volume_db", -40, 0.3)
				tween.tween_callback(func():
					som.stop()
					controleLimite.contar_aud(-1)
					som.queue_free()
				)
		
		sonsAtivos.erase(tipo)
		pitchOriginal.erase(tipo)
		volOriginal.erase(tipo)
