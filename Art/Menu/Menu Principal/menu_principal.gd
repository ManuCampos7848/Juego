extends Control

@onready var sombreros = $Sombreros 
@onready var player = $PlayerFront
@onready var cabellos = $Cabellos
@onready var ropa = $Ropa
@onready var pantalones = $Pantalones

# ______________________ Fade ___________________________________
var fade_timer := 0.0
var fade_completed := false
var fade_duration := 1.5
var fade_out_in_progress := false
var target_scene_path: String = ""

@onready var fade_overlay = ColorRect.new()

# Nueva variable para controlar el cambio de escena
var is_changing_scene: bool = false
var scene_to_load: String = ""

func fade_in(delta):
	if not fade_out_in_progress and not is_changing_scene:
		if fade_timer < fade_duration:
			fade_timer += delta
			fade_overlay.color.a = 1.0 - (fade_timer / fade_duration)
		elif not fade_completed:
			fade_completed = true
			fade_overlay.hide()

func _on_texture_button_2_pressed() -> void:
	# Iniciar fade out y cambiar escena
	start_scene_change("res://Art/Personalizacion/personalizacion_player.tscn", 1.0)

func start_scene_change(scene_path: String, duration: float) -> void:
	if is_changing_scene:
		return  # Evitar múltiples cambios
	
	is_changing_scene = true
	target_scene_path = scene_path
	fade_out_in_progress = true
	fade_completed = false
	fade_timer = 0.0
	fade_duration = duration
	fade_overlay.show()
	fade_overlay.color.a = 0.0

func _process(delta: float) -> void:
	if fade_out_in_progress and is_changing_scene:
		# Fade out
		fade_timer += delta
		var progress = fade_timer / fade_duration
		fade_overlay.color.a = min(progress, 1.0)
		
		if fade_timer >= fade_duration:
			# Cambiar escena cuando el fade termine
			complete_scene_change()
	else:
		# Fade in normal
		fade_in(delta)

func complete_scene_change() -> void:
	if target_scene_path != "":
		get_tree().change_scene_to_file(target_scene_path)
	
	# Resetear variables (por si acaso)
	fade_out_in_progress = false
	is_changing_scene = false
	target_scene_path = ""
	fade_timer = 0.0

func _ready() -> void:
	# Configurar el fade overlay
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	add_child(fade_overlay)
	fade_overlay.hide()
	
	# Iniciar fade in automático
	fade_timer = 0.0
	fade_completed = false
	fade_overlay.show()
	fade_overlay.color.a = 1.0
	
	# Intentar cargar personalización guardadas
	if cargar_personalizacion_guardada():
		print("Personalización cargada desde archivo")
		if Global.cabello == "":
			$Cabellos/Cabello5.hide()
		if Global.pantalon == "":
			$Pantalones/Pantalon1.hide()
	else:
		# Si no hay archivo, iniciar timer aleatorio
		print("No hay datos guardados, iniciando aleatorio...")
		await get_tree().create_timer(1).timeout
		$Timer.start()
		
		
func cargar_personalizacion_guardada() -> bool:
	if not Global.cargar_personalizacion():
	
		return false
	# Cargar skin del personaje
	if Global.skin != "":
		var ruta = "res://Art/Personalizacion/Front/Front" + Global.skin + ".png"
		var texture = load(ruta)
		if texture:
			player.texture = texture
			print("Skin cargada:", Global.skin)
	
	# Cargar cabello
	if Global.cabello != "":
		for i in range(1, 7):
			var cabello_nodo = cabellos.get_node("Cabello" + str(i))
			if cabello_nodo:
				cabello_nodo.hide()
		
		var cabello_nombre = "Cabello" + Global.cabello
		var cabello_guardado = cabellos.get_node(cabello_nombre)
		if cabello_guardado:
			cabello_guardado.show()
			print("Cabello cargado:", cabello_nombre)
	
	# Cargar sombrero
	if Global.sombrero != "":
		for i in range(1, 18):
			var sombrero_nodo = sombreros.get_node("Sombrero" + str(i))
			if sombrero_nodo:
				sombrero_nodo.hide()
		
		var sombrero_nombre = "Sombrero" + Global.sombrero
		var sombrero_guardado = sombreros.get_node(sombrero_nombre)
		if sombrero_guardado:
			sombrero_guardado.show()
			print("Sombrero cargado:", sombrero_nombre)
	
	# Cargar ropa
	if Global.ropa != "":
		for i in range(1, 15):
			var ropa_nodo = ropa.get_node("Ropa" + str(i))
			if ropa_nodo:
				ropa_nodo.hide()
		
		var ropa_nombre = "Ropa" + Global.ropa
		var ropa_guardada = ropa.get_node(ropa_nombre)
		if ropa_guardada:
			ropa_guardada.show()
			print("Ropa cargada:", ropa_nombre)
	
	if Global.pantalon != "":
		for i in range(1, 14):
			var pantalones_nodo = pantalones.get_node("Ropa" + str(i))
			if pantalones_nodo:
				pantalones_nodo.hide()
		
		var pantalon_nombre = "Pantalon" + Global.pantalon
		var pantalon_guardado = pantalones.get_node(pantalon_nombre)
		if pantalon_guardado:
			pantalon_guardado.show()
			print("Ropa cargada:", pantalon_nombre)
	
	return true

func sombrerosAleatorios():
	# Primero ocultar todos los sombreros
	for i in range(1, 18):
		var sombrero = sombreros.get_node("Sombrero" + str(i))
		if sombrero:
			sombrero.hide()
	$Sombreros/Sombrero11.hide()
	# Seleccionar y mostrar un sombrero aleatorio
	var num : int = randi_range(1, 17)
	var sombreroElegido = sombreros.get_node("Sombrero" + str(num))
	if sombreroElegido:
		sombreroElegido.show()

func skinColorPersonajeAleatorio():
	
	# Código original...
	var num = randi_range(1, 45)
	var ruta = "res://Art/Personalizacion/Front/Front" + str(num) + ".png"
	
	var texture = load(ruta)
	if texture:
		player.texture = texture
	else:
		print("Error: No se pudo cargar: ", ruta)
		player.texture = preload("res://Art/Personalizacion/Front/Front1.png")

func cabelloAelatorio():

	# Código original...
	for i in range(1, 7):
		var cabello_nodo = cabellos.get_node("Cabello" + str(i))
		if cabello_nodo:
			cabello_nodo.hide()
	
	var num : int = randi_range(1, 6)
	var cabelloElegido = cabellos.get_node("Cabello" + str(num))
	
	if cabelloElegido:
		cabelloElegido.show()

func ropaAleatoria():
	# Código original...
	for i in range(1, 15):
		var ropa_nodo = ropa.get_node("Ropa" + str(i))
		if ropa_nodo:
			ropa_nodo.hide()
	
	var num : int = randi_range(1, 14)
	var ropaElegida = ropa.get_node("Ropa" + str(num))
	
	if ropaElegida:
		ropaElegida.show()
		print("Mostrando: Ropa" + str(num))
		
func pantalonesAleatorios():
	
	for i in range(1,14):
		var pantalonNodo = pantalones.get_node("Pantalon"+str(i))
		pantalonNodo.hide()
	
	var numAleatorio = randi_range(1,13)
	var pantalonElegido = pantalones.get_node("Pantalon"+str(numAleatorio))
	
	if pantalonElegido:
		pantalonElegido.show()
		
func _on_timer_timeout() -> void:
	sombrerosAleatorios()
	skinColorPersonajeAleatorio()
	cabelloAelatorio()
	ropaAleatoria()
	pantalonesAleatorios()


func salirButton() -> void:
	get_tree().quit()
