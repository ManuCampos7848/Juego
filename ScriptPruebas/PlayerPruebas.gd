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
var gravity = 2
# -----------------------------------------------


# -----------------------------------------------
func _ready():
	cargar_sombrero()  # Cambié el nombre para mayor claridad
# -----------------------------------------------


# -----------------------------------------------
# Funcion para cargar el sombrero seleccionado por el player
func cargar_sombrero():
	# 1. Ocultar todos los sombreros primero
	for i in range(1, 9):
		# Sombreros normales
		var sombrero = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(i))
		if sombrero:
			sombrero.visible = false
		
		# Sombreros laterales
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero" + str(i) + "Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = false
	
	
	
	# 2. Mostrar SIEMPRE el sombrero base seleccionado
	if GlobalPrueba.sombrero_seleccionado == 6:
		# Caso especial para sombrero 6 (versión lateral)
		var sombrero_lateral = get_node_or_null("Accesorios/SombrerosLateral/Sombrero6Lateral")
		if sombrero_lateral:
			sombrero_lateral.visible = true
		else:
			var sprite_lateral = Sprite2D.new()
			sprite_lateral.texture = load(GlobalPrueba.RUTA_SOMBREROS_LATERALES + "Sombrero6Lateral.png")
			sprite_lateral.name = "Sombrero6Lateral"
			$Accesorios/SombrerosLateral.add_child(sprite_lateral)
	else:
		# Mostrar sombrero normal base
		var sombrero_base = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(GlobalPrueba.sombrero_seleccionado))
		if sombrero_base:
			sombrero_base.visible = true
		else:
			var sprite = Sprite2D.new()
			sprite.texture = load(GlobalPrueba.RUTA_SOMBREROS_NORMALES + "Sombrero" + str(GlobalPrueba.sombrero_seleccionado) + ".png")
			sprite.name = "Sombrero" + str(GlobalPrueba.sombrero_seleccionado)
			$Accesorios/Sombreros.add_child(sprite)
	
	# 3. Si hay sombrero combinado, mostrarlo ADEMÁS del base
	if GlobalPrueba.esSombreroCombinado:
		var sombrero_combinado = get_node_or_null("Accesorios/Sombreros/Sombrero" + str(GlobalPrueba.numeroSombreroCombinado))
		if sombrero_combinado:
			sombrero_combinado.visible = true
		else:
			var sprite_combinado = Sprite2D.new()
			sprite_combinado.texture = load(GlobalPrueba.RUTA_SOMBREROS_NORMALES + "Sombrero" + str(GlobalPrueba.numeroSombreroCombinado) + ".png")
			sprite_combinado.name = "Sombrero" + str(GlobalPrueba.numeroSombreroCombinado)
			$Accesorios/Sombreros.add_child(sprite_combinado)
	print(" En Prueba player - Cargando - Combinado: ", GlobalPrueba.esSombreroCombinado, " | Número: ", GlobalPrueba.numeroSombreroCombinado)
	print(GlobalPrueba.sombrero_seleccionado)
# -----------------------------------------------


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
