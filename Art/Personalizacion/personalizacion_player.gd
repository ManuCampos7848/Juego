extends Control

@onready var recuadro = $Recuadro
@onready var cabellos = $Cabellos
	
@onready var sombreros =$Sombreros 

var fade_timer := 0.0
var fade_completed := false
var fade_duration := 1
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

func _process(delta: float) -> void:
	fade_in(delta)
	
func _ready() -> void:
	$Timer.start()
	seccionColores()
	
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	add_child(fade_overlay)
	
		# Cargar la personalización guardada
	var indice_cargado = Global.sombrero_seleccionado
	if indice_cargado < listaFront.size():  # Verificar que el índice sea válido
		aplicar_personalizacion(indice_cargado)
	

func cabelloAelatorio():
	# Ocultar todos los cabellos
	for i in range(1, 7):  # Cambié a 7 si tienes 6 cabellos
		var cabello_nodo = cabellos.get_node("Cabello" + str(i))  # Nombre diferente
		if cabello_nodo:
			cabello_nodo.hide()
	
	# Mostrar un cabello aleatorio
	var num : int = randi_range(1, 6)
	var cabelloElegido = cabellos.get_node("Cabello" + str(num))  # 'cabello' sigue siendo el contenedor
	
	if cabelloElegido:
		cabelloElegido.show()
		#print("Mostrando: Cabello" + str(num))
	
func _on_timer_timeout() -> void:
	#sombrerosAleatorios()
	#skinColorPersonajeAleatorio()
	cabelloAelatorio()
	#ropaAleatoria()
	pass	

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
# __________________________________  Codigo seleccion de colores __________________________
# Listas de recursos
var listaFront = []       # Vistas frontales
var listaRigth = []       # Vistas derecha (para animación)
var listaWalkD = []       # Pasos derecha
var listaWalkI = []       # Pasos izquierda

var indiceActual = 0      # Índice actual de personalización
var is_moving = false     # Para controlar si el personaje se está moviendo

var formas_por_indice: Dictionary

func seccionColores():
		# Codigo seccion colores
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Asociar índice con nodo manualmente
	formas_por_indice = {}
	var shapes = $ColorSkins.get_children()
	var idx = 0
	for child in shapes:
		if child is CollisionShape2D:
			formas_por_indice[idx] = child
			idx += 1

	cargar_imagenes()
	aplicar_personalizacion(0)
	# Configuración inicial de visibilidad
	$PlayerFront.visible = true
	$PlayerWalk.visible = false
	$PlayerWalk.stop()  # Asegurarse que la animación no está corriendo

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if formas_por_indice.has(shape_idx):
			var shape = formas_por_indice[shape_idx]
			print("Clic sobre:", shape.name)
			print(shape.position)
			recuadro.global_position = shape.global_position
			match shape.name:
				"Sprite1":
					print("¡Parcero!")
					aplicar_personalizacion(0)
				"Sprite2":
					aplicar_personalizacion(1)
				"Sprite3":
					aplicar_personalizacion(2)
				"Sprite4":
					aplicar_personalizacion(3)
				"Sprite5":
					aplicar_personalizacion(4)
				"Sprite6":
					aplicar_personalizacion(5)
				"Sprite7":
					aplicar_personalizacion(6)
				"Sprite8":
					aplicar_personalizacion(7)
				"Sprite9":
					aplicar_personalizacion(8)
				"Sprite10":
					aplicar_personalizacion(9)
				"Sprite11":
					aplicar_personalizacion(10)
				"Sprite12":
					aplicar_personalizacion(11)
				"Sprite13":
					aplicar_personalizacion(12)
				"Sprite14":
					aplicar_personalizacion(13)
				"Sprite15":
					aplicar_personalizacion(14)
				"Sprite16":
					aplicar_personalizacion(15)
				"Sprite17":
					aplicar_personalizacion(16)
				"Sprite18":
					aplicar_personalizacion(17)
				"Sprite19":
					aplicar_personalizacion(18)
				"Sprite20":
					aplicar_personalizacion(19)
				"Sprite21":
					aplicar_personalizacion(20)
				"Sprite22":
					aplicar_personalizacion(21)
				"Sprite23":
					aplicar_personalizacion(22)
				"Sprite24":
					aplicar_personalizacion(23)
				"Sprite25":
					aplicar_personalizacion(24)
				"Sprite26":
					aplicar_personalizacion(25)
				"Sprite27":
					aplicar_personalizacion(26)
				"Sprite28":
					aplicar_personalizacion(27)
				"Sprite29":
					aplicar_personalizacion(28)
				"Sprite30":
					aplicar_personalizacion(29)
				"Sprite31":
					aplicar_personalizacion(30)
				"Sprite32":
					aplicar_personalizacion(31)
				"Sprite33":
					aplicar_personalizacion(32)
				"Sprite34":
					aplicar_personalizacion(33)
				"Sprite35":
					aplicar_personalizacion(34)
				"Sprite36":
					aplicar_personalizacion(35)
				"Sprite37":
					aplicar_personalizacion(36)
				"Sprite38":
					aplicar_personalizacion(37)
				"Sprite39":
					aplicar_personalizacion(38)
				"Sprite40":
					aplicar_personalizacion(39)
				"Sprite41":
					aplicar_personalizacion(40)
				"Sprite42":
					aplicar_personalizacion(41)
				"Sprite43":
					aplicar_personalizacion(42)
				"Sprite44":
					aplicar_personalizacion(43)
				"Sprite45":
					aplicar_personalizacion(44)
				"Sprite46":
					aplicar_personalizacion(45)

func _on_btn_derecha_pressed() -> void:
	
	$PlayerFront.visible = false
	$PlayerWalk.visible = true
	
	$PlayerWalk.flip_h = false
	$PlayerWalk.play("walk")
	pass # Replace with function body.

func _on_btn_izquierda_pressed() -> void:
	
	$PlayerFront.visible = false
	$PlayerWalk.visible = true
	
	$PlayerWalk.flip_h = true
	$PlayerWalk.play("walk")
	pass # Replace with function body.

func _on_btn_front_pressed() -> void:
	$PlayerWalk.visible = false
	$PlayerFront.visible = true

func cargar_imagenes():
	# Cargamos todas las variantes (1-45)
	for i in range(1, 47):
		# Cargar vista frontal
		var pathFront = "res://Art/Personalizacion/Front/Front%d.png" % i
		if ResourceLoader.exists(pathFront):
			listaFront.append(load(pathFront))
		else:
			listaFront.append(null)
			print("Advertencia: No se encontró ", pathFront)
		
		# Cargar vista derecha (para animación)
		var pathRigth = "res://Art/Personalizacion/Rigth/Rigth%d.png" % i
		if ResourceLoader.exists(pathRigth):
			listaRigth.append(load(pathRigth))
		else:
			listaRigth.append(null)
			print("Advertencia: No se encontró ", pathRigth)
		
		# Cargar pasos derecha
		var pathWalkD = "res://Art/Personalizacion/WalkDerecha/WalkD%d.png" % i
		if ResourceLoader.exists(pathWalkD):
			listaWalkD.append(load(pathWalkD))
		else:
			listaWalkD.append(null)
			print("Advertencia: No se encontró ", pathWalkD)
		
		# Cargar pasos izquierda
		var pathWalkI = "res://Art/Personalizacion/WalkIzquierda/WalkI%d.png" % i
		if ResourceLoader.exists(pathWalkI):
			listaWalkI.append(load(pathWalkI))
		else:
			listaWalkI.append(null)
			print("Advertencia: No se encontró ", pathWalkI)


var texturaFront
var texturaWalkD
var texturaWalkI
var ultimo_indice_seleccionado = 0

func aplicar_personalizacion(indice: int):
	
	#print(listaFront[indice].position)
	# Aplicar al Sprite frontal
	if indice < listaFront.size() and listaFront[indice] != null:
		$PlayerFront.texture = listaFront[indice]
	
	# Configurar la animación walk del AnimatedSprite
	if indice < listaRigth.size() and listaRigth[indice] != null:
		var frames = SpriteFrames.new()
		frames.add_animation("walk")
		frames.add_frame("walk", listaRigth[indice])
		print("Frame 1 (Right): ", listaRigth[indice].resource_path if listaRigth[indice] else "null")

		frames.add_frame("walk", listaWalkD[indice])
		print("Frame 2 (WalkD): ", listaWalkD[indice].resource_path if listaWalkD[indice] else "null")

		frames.add_frame("walk", listaRigth[indice])
		print("Frame 3 (Right): ", listaRigth[indice].resource_path if listaRigth[indice] else "null")

		frames.add_frame("walk", listaWalkI[indice])
		print("Frame 4 (WalkI): ", listaWalkI[indice].resource_path if listaWalkI[indice] else "null")

		$PlayerWalk.sprite_frames = frames
		$PlayerWalk.play("walk")
	ultimo_indice_seleccionado = indice
	guardar_persistencia_frames()


func guardar_persistencia_frames():
	# Usamos el sistema existente de Global para guardar solo el índice
	Global.sombrero_seleccionado = ultimo_indice_seleccionado
	Global.save_settings()
# ___________________________________________________________________________________________
func _on_Iniciar_pressed():
	Global.save_settings()
	get_tree().change_scene_to_file("res://mundo.tscn")


func _on_eleccion_carpeta_body_exited(body: Node2D) -> void:
	
	match body.name:
		"Colores":
			print("Carolo1")
		"Peinados":
			print("Carolo2")
	pass # Replace with function body.
