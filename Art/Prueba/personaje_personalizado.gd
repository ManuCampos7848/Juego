extends CharacterBody2D



# -----------------------------------------------
signal barreraBajaPierde
signal caer
# -----------------------------------------------


# -----------------------------------------------
const SPEED = 155.0
const JUMP_VELOCITY = -300.0
# -----------------------------------------------


# -----------------------------------------------
# Gravedad
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -----------------------------------------------



var lista_front = []
var lista_right = []
var lista_walkD = []
var lista_walkI = []
# -----------------------------------------------

	
	
func _ready():
	

	#$CPUParticles2D.scale_amount_min = 0.01 # Muy pequeño
	#$CPUParticles2D.scale_amount_max = 0.09  # Más grande
	
	
	
	scale = Vector2(1,1)
	cargar_sombrero()  # Cambié el nombre para mayor claridad
# -----------------------------------------------




# Función para obtener la textura correcta del sombrero
func obtener_textura_sombrero(hat_id: int, es_principal: bool) -> Texture2D:
	var path = ""
	
	# Reglas especiales para sombreros laterales
	if hat_id in [2, 6]:  # Sombreros que tienen versión lateral
		if es_principal || (hat_id == 2 && !es_principal):  # El 2 siempre lateral, el 6 solo como principal
			path = Global.RUTA_SOMBREROS_LATERALES + "Sombrero" + str(hat_id) + "Lateral.png"
	
	# Si no aplicó regla lateral o no encontró el archivo, usa normal
	if path == "" || !FileAccess.file_exists(path):
		path = Global.RUTA_SOMBREROS_NORMALES + "Sombrero" + str(hat_id) + ".png"
	
	if FileAccess.file_exists(path):
		return load(path)
	else:
		printerr("Error: No se encontró textura para sombrero ", hat_id)
		return null

# Función principal para cargar los sombreros
func cargar_sombrero():
	# 1. Ocultar todos los sombreros primero
	for i in range(1, 9):
		var nodo = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(i))
		if nodo:
			nodo.visible = false
	
	# 2. Cargar sombrero principal
	var sombrero_principal = obtener_nodo_sombrero(Global.sombrero_seleccionado)
	var textura_principal = obtener_textura_sombrero(Global.sombrero_seleccionado, true)
	
	if textura_principal:
		sombrero_principal.texture = textura_principal
		sombrero_principal.visible = true
	
	# 3. Cargar sombrero combinado (si existe)
	if Global.esSombreroCombinado && Global.numeroSombreroCombinado > 0:
		var sombrero_combinado = obtener_nodo_sombrero(Global.numeroSombreroCombinado)
		var textura_combinada = obtener_textura_sombrero(Global.numeroSombreroCombinado, false)
		
		if textura_combinada:
			sombrero_combinado.texture = textura_combinada
			sombrero_combinado.visible = true

# Función auxiliar para obtener/crear nodos
func obtener_nodo_sombrero(hat_id: int) -> Sprite2D:
	var nodo = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(hat_id))
	if !nodo:
		nodo = Sprite2D.new()
		nodo.name = "Sombrero" + str(hat_id)
		$Accesorios/Sombreros.add_child(nodo)
		nodo.owner = get_tree().edited_scene_root
	return nodo
# -----------------------------------------------


func sombreroLateralCombinado(numeroSombreroCombinado):
	var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero" + str(numeroSombreroCombinado) + "Lateral")
	if sombrero_lateral:
		sombrero_lateral.visible = true

const SUAVIDAD_FRENADO = 1  # Valor entre 0 (lento) y 1 (instantáneo)

func _physics_process(delta):
	# (Mantén tu lógica de movimiento existente)
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Control de partículas
#	var should_emit = direction != 0 and is_on_floor()
#	$ParticulasFlores.emitting = should_emit
	
#	if should_emit:
#		var dust_direction = -sign(direction)  # Invertir la dirección
#		$ParticulasFlores.direction.x = dust_direction
#		$ParticulasFlores.position.x = abs($ParticulasFlores.position.x) * dust_direction
	
	# Animaciones
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
		# Asegurar que los accesorios también se volteen
		$Accesorios.scale.x = 1
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true
		# Voltear accesorios junto con el personaje
		$Accesorios.scale.x = -1

	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Perder":
		print("cayo")
		barreraBajaPierde.emit()
