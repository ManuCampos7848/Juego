extends Control

@onready var recuadro = $Recuadro
@onready var cabellos = $Cabellos
@onready var sombreros =$Sombreros
@onready var ropa = $Ropa
@onready var player = $PlayerFront


# __________________________ Recuadro _________________________________________
var blink_timer := 0.0
@export var blink_speed := 8.0  # Más rápido que el anterior (4 ciclos por segundo)
var is_blinking := true
# __________________________ Cargados en Persistencia _________________________
@onready var sombrerosCargadosPersistencia  = $SombrerosInPlayer 
@onready var cabellosCargadosPersistencia = $CabellosInPlayer
@onready var ropaCargadosPersistencia = $RopaInPlayer

# __________________________ Variables para guardar en Persistencia _________________________
var colorElegidoPersistencia : String = ""
var cabelloElegidoPersistencia : String = ""
var sombreroElegidoPersistencia : String = ""
var ropaElegidaPersistencia : String = ""


# ___________________________ FADE IN/OUT ________________________________________________________
var fade_timer := 0.0
var fade_completed := false
var fade_duration := 1
var fade_out_in_progress := false
var target_scene_path: String = ""
var is_changing_scene: bool = false

@onready var fade_overlay = ColorRect.new()

func fade_in(delta):
	if not fade_out_in_progress and not is_changing_scene:
		if fade_timer < fade_duration:
			fade_timer += delta
			fade_overlay.color.a = 1.0 - (fade_timer / fade_duration)
		if fade_timer >= fade_duration:
			fade_completed = true
			fade_overlay.hide()
			
# Añade esta función para iniciar el cambio de escena
func start_scene_change(scene_path: String) -> void:
	if is_changing_scene:
		return  # Evitar múltiples cambios
	
	is_changing_scene = true
	target_scene_path = scene_path
	fade_out_in_progress = true
	fade_completed = false
	fade_timer = 0.0
	fade_overlay.show()
	fade_overlay.color.a = 0.0

func _process(delta: float) -> void:

	if is_blinking:
		blink_timer += delta
		recuadro.modulate.a = 1.0 if fmod(blink_timer, 0.3) < 0.2 else 0.0
		
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

# Añade esta función para completar el cambio de escena
func complete_scene_change() -> void:
	if target_scene_path != "":
		get_tree().change_scene_to_file(target_scene_path)
	
	# Resetear variables (por si acaso)
	fade_out_in_progress = false
	is_changing_scene = false
	target_scene_path = ""
	fade_timer = 0.0

# ________________________________________________________________________________________________
func _ready() -> void:
	$Timer.start()
	seccionColores()
	seccionIndicesSeleccion()
	seccionSombrerosIndices()
	seccionPeinadosIndices()
	seccionRopaIndices()
	
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	add_child(fade_overlay)
	
	if cargar_personalizacion_guardada():
		cargar_personalizacion_guardada()
		print("Personalización cargada desde archivo")
	
# _________________ ANIMACIONES CAMBIO DE ACCESORIO (INDICES) ____________________________________
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
	
func ropaAleatoria():
	# Ocultar todos los cabellos
	for i in range(1, 15):  # Cambié a 7 si tienes 6 cabellos
		var ropa_nodo = ropa.get_node("Ropa" + str(i))  # Nombre diferente
		if ropa_nodo:
			ropa_nodo.hide()
	
	# Mostrar un cabello aleatorio
	var num : int = randi_range(1, 14)
	var ropaElegida = ropa.get_node("Ropa" + str(num))  # 'cabello' sigue siendo el contenedor
	
	if ropaElegida:
		ropaElegida.show()
		
		
func _on_timer_timeout() -> void:
	sombrerosAleatorios()
	#skinColorPersonajeAleatorio()
	cabelloAelatorio()
	ropaAleatoria()
	pass

func sombrerosAleatorios():
		# Primero ocultar todos los sombreros
	for i in range(1, 17):
		var sombrero = sombreros.get_node("Sombrero" + str(i))
		if sombrero:
			sombrero.hide()
	$Sombreros/Sombrero17.hide()
	# Seleccionar y mostrar un sombrero aleatorio
	var num : int = randi_range(1, 17)  # Usa randi_range para enteros
	var sombreroElegido = sombreros.get_node("Sombrero" + str(num))
	if sombreroElegido:
		sombreroElegido.show()
# ________________________________________________________________________________________________		



# __________________________________  Codigo seleccion de colores __________________________
# Listas de recursos
var listaFront = []       # Vistas frontales


var indiceActual = 0      # Índice actual de personalización
var is_moving = false     # Para controlar si el personaje se está moviendo



# ____________ ACTIVAR COLISION DE ACCESORIOS Y COLORES __________________________________________
var sombrerosPorIndice: Dictionary
var formas_por_indice: Dictionary
var indiceEleccion: Dictionary
var peinadosPorIndice: Dictionary
var ropaPorIndice: Dictionary


func seccionRopaIndices():
	ropaPorIndice = {}
	var idx = 0
	var shapes = $SkinRopa.get_children()
	for child in shapes:
		if child is CollisionShape2D:
			ropaPorIndice[idx] = child
			idx += 1
			
			
func seccionPeinadosIndices():
	peinadosPorIndice = {}
	var idx = 0
	var shapes = $SkinPeinados.get_children()
	for child in shapes:
		if child is CollisionShape2D:
			peinadosPorIndice[idx] = child
			idx += 1
			
			
func seccionSombrerosIndices():
	sombrerosPorIndice = {}
	var idx = 0
	var shapes = $SkinSombreros.get_children()
	for child in shapes:
		if child is CollisionShape2D:
			sombrerosPorIndice[idx] = child
			idx += 1

func seccionIndicesSeleccion():
	indiceEleccion = {}
	var idx = 0
	var shapes = $IndiceEleccion.get_children()
	for child in shapes:
		if child is CollisionShape2D:
			indiceEleccion[idx] = child
			idx += 1
	
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
	
func esconderElecciones():
	recuadro.global_position = Vector2(185,197)
	var skinCabellos = $SkinSombreros.get_children()
	for skinCabello in skinCabellos:
		if skinCabello is CollisionShape2D:
			skinCabello.disabled = true
		skinCabello.hide()
		
	
	var colorSkins = $ColorSkins.get_children()
	for coloresDeSkin in colorSkins:
		if coloresDeSkin is CollisionShape2D:
			coloresDeSkin.disabled = true
		coloresDeSkin.hide()
	
	var skinsPeinados = $SkinPeinados.get_children()
	for skinPeinado in skinsPeinados:
		if skinPeinado is CollisionShape2D:
			skinPeinado.disabled = true
		skinPeinado.hide()
	
	var skinRopas = $SkinRopa.get_children()
	for skinRopa in skinRopas:
		if skinRopa is CollisionShape2D:
			skinRopa.disabled = true
		skinRopa.hide()
	
	var elecciones = $Elecciones.get_children()
	for eleccion in elecciones:
		eleccion.hide()
# ________________________________________________________________________________________________	

# Puedes crear una función para reutilizar este código
func habilitar_hijos_de(nodo: Node, habilitar: bool = true) -> void:
	for child in nodo.get_children():
		if child.has_method("set_disabled"):
			child.disabled = !habilitar
		# También puedes manejar otros tipos de nodos
		if child is CanvasItem:
			child.visible = habilitar
			
# ________________ FUNCIONES CON EL CLICK IZQUIERDO (SELECCION DE ACCESORIOS) ____________________
func _on_indice_eleccion_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if indiceEleccion.has(shape_idx):
			var shape = indiceEleccion[shape_idx]
			print("Clic sobre:", shape.name)
			match shape.name:
				"ColoresIndice":
					esconderElecciones()
					$ColorSkins.show()
					habilitar_hijos_de($ColorSkins)
					$Elecciones/Eleccion1.show()
				"CabellosIndice":
					esconderElecciones()
					$SkinPeinados.show()
					habilitar_hijos_de($SkinPeinados)
					$Elecciones/Eleccion2.show()
				"SombrerosIndice":
					esconderElecciones()
					$SkinSombreros.show()
					habilitar_hijos_de($SkinSombreros)
					$Elecciones/Eleccion3.show()
				"RopaIndice":
					esconderElecciones()
					$SkinRopa.show()
					habilitar_hijos_de($SkinRopa)
					$Elecciones/Eleccion4.show()
				"PantalonesIndice":
					esconderElecciones()
					$Elecciones/Eleccion5.show()
					
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if formas_por_indice.has(shape_idx):
			var shape = formas_por_indice[shape_idx]
			print("Clic sobre:", shape.name)
			colorElegidoPersistencia = shape.name
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
# ________________________________________________________________________________________________	


func _on_btn_derecha_pressed() -> void:
	
	$PlayerFront.visible = false
	$PlayerWalk.visible = true
	
	$PlayerWalk.flip_h = false
	$PlayerWalk.play("walk")
	pass # Replace with function body.

func _on_btn_izquierda_pressed() -> void:
	
	start_scene_change("res://Art/Menu/Menu Principal/menu_principal.tscn")
	
	#$PlayerFront.visible = false
	#$PlayerWalk.visible = true
	
	#$PlayerWalk.flip_h = true
	#$PlayerWalk.play("walk")
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
		
		


var texturaFront
var ultimo_indice_seleccionado = 0

func aplicar_personalizacion(indice: int):
	if indice < listaFront.size() and listaFront[indice] != null:
		$PlayerFront.texture = listaFront[indice]
	
	ultimo_indice_seleccionado = indice
	print("Skin guardada: ", colorElegidoPersistencia)
	


# ___________________________________________________________________________________________


func _on_Iniciar_pressed():
	get_tree().change_scene_to_file("res://mundo.tscn")


func _on_skin_cabellos_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if peinadosPorIndice.has(shape_idx):
			var shape = peinadosPorIndice[shape_idx]
			cabelloElegidoPersistencia = shape.name
			recuadro.global_position = shape.global_position
			match shape.name:
				"Sprite1":
					cambiarPeinado($CabellosInPlayer/Cabello1)
				"Sprite2":
					cambiarPeinado($CabellosInPlayer/Cabello2)
				"Sprite3":
					cambiarPeinado($CabellosInPlayer/Cabello3)
				"Sprite4":
					cambiarPeinado($CabellosInPlayer/Cabello4)
				"Sprite5":
					cambiarPeinado($CabellosInPlayer/Cabello5)
				"Sprite6":
					cambiarPeinado($CabellosInPlayer/Cabello6)
				_:
					for cabellosPlayer in $CabellosInPlayer.get_children():
						cabellosPlayer.hide()
					Global.ropa = ""
					

func _on_skin_sombreros_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if sombrerosPorIndice.has(shape_idx):
			var shape = sombrerosPorIndice[shape_idx]
			recuadro.global_position = shape.global_position
			sombreroElegidoPersistencia = shape.name
			match shape.name:
				"Sprite1":
					cambiarSombrero($SombrerosInPlayer/Sombrero1)
				"Sprite2":
					cambiarSombrero($SombrerosInPlayer/Sombrero2)
				"Sprite3":
					cambiarSombrero($SombrerosInPlayer/Sombrero3)
				"Sprite4":
					cambiarSombrero($SombrerosInPlayer/Sombrero4)
				"Sprite5":
					cambiarSombrero($SombrerosInPlayer/Sombrero5)
				"Sprite6":
					cambiarSombrero($SombrerosInPlayer/Sombrero6)
				"Sprite7":
					cambiarSombrero($SombrerosInPlayer/Sombrero7)
				"Sprite8":
					cambiarSombrero($SombrerosInPlayer/Sombrero8)
				"Sprite9":
					cambiarSombrero($SombrerosInPlayer/Sombrero9)
				"Sprite10":
					cambiarSombrero($SombrerosInPlayer/Sombrero10)
				"Sprite11":
					cambiarSombrero($SombrerosInPlayer/Sombrero11)
				"Sprite12":
					cambiarSombrero($SombrerosInPlayer/Sombrero12)
				"Sprite13":
					cambiarSombrero($SombrerosInPlayer/Sombrero13)
				"Sprite14":
					cambiarSombrero($SombrerosInPlayer/Sombrero14)
				"Sprite15":
					cambiarSombrero($SombrerosInPlayer/Sombrero15)
				"Sprite16":
					cambiarSombrero($SombrerosInPlayer/Sombrero16)
				"Sprite17":
					cambiarSombrero($SombrerosInPlayer/Sombrero17)
				_:
					for sombrero in $SombrerosInPlayer.get_children():
						sombrero.hide()
					Global.sombrero = ""

func _on_skin_ropa_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if ropaPorIndice.has(shape_idx):
			var shape = ropaPorIndice[shape_idx]
			recuadro.global_position = shape.global_position
			ropaElegidaPersistencia = shape.name
			match shape.name:
				"Sprite1":
					cambiarRopa($RopaInPlayer/Ropa1)
				"Sprite2":
					cambiarRopa($RopaInPlayer/Ropa2)
				"Sprite3":
					cambiarRopa($RopaInPlayer/Ropa3)
				"Sprite4":
					cambiarRopa($RopaInPlayer/Ropa4)
				"Sprite5":
					cambiarRopa($RopaInPlayer/Ropa5)
				"Sprite6":
					cambiarRopa($RopaInPlayer/Ropa6)
				"Sprite7":
					cambiarRopa($RopaInPlayer/Ropa7)
				"Sprite8":
					cambiarRopa($RopaInPlayer/Ropa8)
				"Sprite9":
					cambiarRopa($RopaInPlayer/Ropa9)
				"Sprite10":
					cambiarRopa($RopaInPlayer/Ropa10)
				"Sprite11":
					cambiarRopa($RopaInPlayer/Ropa11)
				"Sprite12":
					cambiarRopa($RopaInPlayer/Ropa12)
				"Sprite13":
					cambiarRopa($RopaInPlayer/Ropa13)
				"Sprite14":
					cambiarRopa($RopaInPlayer/Ropa14)
				_:
					for ropaInPlayer in $RopaInPlayer.get_children():
						ropaInPlayer.hide()
					Global.ropa = ""
				

func cambiarPeinado(cabelloElegido):
	for cabello in $CabellosInPlayer.get_children():
		cabello.hide()
	cabelloElegido.show()
	

func cambiarSombrero(sombreroElegido):
	for sombrero in $SombrerosInPlayer.get_children():
		sombrero.hide()
	sombreroElegido.show()

func cambiarRopa(ropaElegida):
	for ropaInPlayer in $RopaInPlayer.get_children():
		ropaInPlayer.hide()
	ropaElegida.show()
	
   

func _on_guardar_pressed() -> void:
	# Guardar SOLO NÚMEROS pero registrando qué tipo era
	
	Global.skin = colorElegidoPersistencia.replace("Sprite", "")
	Global.cabello = cabelloElegidoPersistencia.replace("Sprite", "")
	Global.sombrero = sombreroElegidoPersistencia.replace("Sprite", "")
	Global.ropa = ropaElegidaPersistencia.replace("Sprite", "")
	
	# Guardar en archivo local
	Global.guardar_personalizacion()
	
	print("Datos guardados (números):")
	print("Skin:", Global.skin, " Cabello:", Global.cabello, 
		  " Sombrero:", Global.sombrero, " Ropa:", Global.ropa)
	$Label1.show()

func _on_resetear_datos_pressed() -> void:
	var save_path = "user://personalizacion_save.json"
	
	# Eliminar archivo
	DirAccess.remove_absolute(save_path)
	
	# Resetear valores en Global
	Global.skin = ""
	Global.cabello = ""
	Global.sombrero = ""
	Global.ropa = ""
	
	# Resetear variables locales
	colorElegidoPersistencia = ""
	cabelloElegidoPersistencia = ""
	sombreroElegidoPersistencia = ""
	ropaElegidaPersistencia = ""
	
	# Resetear visualización
	aplicar_personalizacion(0)  # Skin por defecto
	
	# Ocultar todos los accesorios
	for cabelloInplayer in $CabellosInPlayer.get_children():
		cabelloInplayer.hide()
	for sombreroInplayer in $SombrerosInPlayer.get_children():
		sombreroInplayer.hide()
	for ropaInplayer in $RopaInPlayer.get_children():
		ropaInplayer.hide()
	
	$Label2.show()
	print("✅ Datos reseteados completamente")

func cargar_personalizacion_guardada():
	
	colorElegidoPersistencia = Global.skin
	cabelloElegidoPersistencia = Global.cabello
	sombreroElegidoPersistencia = Global.sombrero
	ropaElegidaPersistencia = Global.ropa
	
# Cargar skin del personaje
	if Global.skin != "":
		var ruta = "res://Art/Personalizacion/Front/Front" + Global.skin + ".png"
		var texture = load(ruta)
		if texture:
			player.texture = texture
			print("Skin cargada:", Global.skin)
	
	# Cargar cabello
	if Global.cabello != "" and Global.cabello != "null":  # ← AQUÍ
		# 1. Ocultar todos
		for i in $CabellosInPlayer.get_children():
			i.hide()
		
		# 2. Buscar el nodo específico
		var cabello_nodo = $CabellosInPlayer.get_node("Cabello" + str(Global.cabello))
		
		# 3. Verificar que existe ANTES de mostrar
		if cabello_nodo != null:
			cabello_nodo.show()
			print("Cabello cargado: Cabello" + str(Global.cabello))
		else:
			print("⚠️ No existe Cabello" + str(Global.cabello))

	
	
	# Cargar sombrero
	# Cargar sombrero - misma lógica
	if Global.sombrero != "" and Global.sombrero != "null":
		for i in $SombrerosInPlayer.get_children():
			i.hide()
		
		var sombrero_nodo = $SombrerosInPlayer.get_node("Sombrero" + str(Global.sombrero))
		if sombrero_nodo != null:
			sombrero_nodo.show()
	
	# Cargar ropa - misma lógica
	if Global.ropa != "" and Global.ropa != "null":
		for i in $RopaInPlayer.get_children():
			i.hide()
		
		var ropa_nodo = $RopaInPlayer.get_node("Ropa" + str(Global.ropa))
		if ropa_nodo != null:
			ropa_nodo.show()
	
	return true
		
