extends Control

@onready var sombreros =$Sombreros 
@onready var player = $PlayerFront
@onready var cabellos = $Cabellos
@onready var ropa = $Ropa
# Called when the node enters the scene tree for the first time.



# ______________________ Fade ___________________________________
var fade_timer := 0.0
var fade_completed := false
var fade_duration := 1.5
var fade_out_in_progress := false

@onready var fade_overlay = ColorRect.new()

func fade_in(delta):
	if not fade_out_in_progress:
		if fade_timer < fade_duration:
			fade_timer += delta
			fade_overlay.color.a = 1.0 - (fade_timer / fade_duration)
		if fade_timer >= fade_duration:
			fade_completed = true
			fade_overlay.hide()

func fade_out(duration: float = 1.5):
	# Marcar que estamos en fade-out
	fade_out_in_progress = true
	fade_overlay.show()
	
	# Resetear timer y empezar desde transparente
	fade_timer = 0.0
	fade_duration = duration
	fade_overlay.color.a = 0.0
	
	# Animar de transparente (0) a opaco (1)
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 1.0, duration)
	await tween.finished
	
	# Cuando termina, marcar como completado
	fade_out_in_progress = false
	fade_completed = true
# _______________________________________________________________

func _on_texture_button_2_pressed() -> void:
	await fade_out(1)
	get_tree().change_scene_to_file("res://Art/Personalizacion/personalizacion_player.tscn")
	

func _process(delta: float) -> void:
	fade_in(delta)

func _ready() -> void:
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	add_child(fade_overlay)
	
	await get_tree().create_timer(1).timeout
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.

	
func sombrerosAleatorios():
		# Primero ocultar todos los sombreros
	for i in range(1, 11):
		var sombrero = sombreros.get_node("Sombrero" + str(i))
		if sombrero:
			sombrero.hide()
	$Sombreros/Sombrero11.hide()
	# Seleccionar y mostrar un sombrero aleatorio
	var num : int = randi_range(1, 11)  # Usa randi_range para enteros
	var sombreroElegido = sombreros.get_node("Sombrero" + str(num))
	if sombreroElegido:
		sombreroElegido.show()
		#print("Mostrando: Sombrero" + str(num))


func skinColorPersonajeAleatorio():
	var num = randi_range(1, 45)
	var ruta = "res://Art/Personalizacion/Front/Front" + str(num) + ".png"
	
	# Intenta cargar directamente
	var texture = load(ruta)
	if texture:
		player.texture = texture
	else:
		print("Error: No se pudo cargar: ", ruta)
		player.texture = preload("res://Art/Personalizacion/Front/Front1.png")  # preload garantiza que existe


func cabelloAelatorio():
	# Ocultar todos los cabellos
	for i in range(1, 6):  # Cambié a 7 si tienes 6 cabellos
		var cabello_nodo = cabellos.get_node("Cabello" + str(i))  # Nombre diferente
		if cabello_nodo:
			cabello_nodo.hide()
	
	# Mostrar un cabello aleatorio
	var num : int = randi_range(1, 5)
	var cabelloElegido = cabellos.get_node("Cabello" + str(num))  # 'cabello' sigue siendo el contenedor
	
	if cabelloElegido:
		cabelloElegido.show()
		#print("Mostrando: Cabello" + str(num))

func ropaAleatoria():
		# Ocultar todos los cabellos
	for i in range(1, 6):  # Cambié a 7 si tienes 6 cabellos
		var ropa_nodo = ropa.get_node("Ropa" + str(i))  # Nombre diferente
		if ropa_nodo:
			ropa_nodo.hide()
	
	# Mostrar un cabello aleatorio
	var num : int = randi_range(1, 5)
	var ropaElegida = ropa.get_node("Ropa" + str(num))  # 'cabello' sigue siendo el contenedor
	
	if ropaElegida:
		ropaElegida.show()
		print("Mostrando: ropa" + str(num))
		
		
func _on_timer_timeout() -> void:
	sombrerosAleatorios()
	skinColorPersonajeAleatorio()
	cabelloAelatorio()
	ropaAleatoria()
	pass
