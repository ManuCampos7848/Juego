extends Node2D

# -----------------------------------------------------------
#  Atributos para colisiones y animaciones
@onready var player = $Personaje
@onready var contadorVida = $ContadorVida/Vidas
@onready var elevador = $Elevador
# -----------------------------------------------------------


# -----------------------------------------------------------
# Persistencia de la vida
var vidas = Global.vidas_persistentes 
# -----------------------------------------------------------



# -----------------------------------------------------------
# Variables locales necesarias
var nubes_caidas = {}
var tween
var elevador_moviendose_abajo = true
var posicion_superior = 400
var posicion_inferior = 500
# -----------------------------------------------------------

# -----------------------------------------------------------
func _ready():
	tween  = create_tween()
	contadorVida.text = str(vidas)
	iniciar_movimiento_elevador()
# -----------------------------------------------------------

# -----------------------------------------------------------
# Funcion para que la nube funcione como un elevador
func iniciar_movimiento_elevador():
	var target_position
	
	if elevador_moviendose_abajo:
		target_position = posicion_inferior
	else:
		target_position = posicion_superior
	var tween = create_tween()
	tween.tween_property(elevador, "position:y", target_position, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(_on_tween_completed)
# -----------------------------------------------------------




# -----------------------------------------------------------
# Funcion complementaria al elevador
func _on_tween_completed():
	# Cambiar la dirección cuando el tween termina
	elevador_moviendose_abajo = !elevador_moviendose_abajo
	iniciar_movimiento_elevador()
# -----------------------------------------------------------





# -----------------------------------------------------------
# Proces delta que mira la posicion del jugador para hacer caer las nubes
func _process(delta):
	# Actualizar la posición del jugador en cada frame
	var posicionPlayer = player.position
	# Teletransporte si el jugador pasa cierta posición
	if posicionPlayer.x >= 1965 and posicionPlayer.y >= 456:
			
		player.position = Vector2(1870, 397)
		# Obtener todas las nubes en el grupo "bloqueDesprendido"
	for nube in get_tree().get_nodes_in_group("bloqueDesprendido"):
		if nube.position.y > get_viewport_rect().size.y + 100:  # 100px de margen
			nube.queue_free()  # Elimina la nube si está muy abajo
		caerNube(nube, nube.position.x, posicionPlayer)
	# -----------------------------------------------------------
# -----------------------------------------------------------
		


# -----------------------------------------------------------
# Funcion para hacer caer las nubes cuando el jugador pase sobre ellas
func caerNube(nube, posicionNube, posicionPlayer):
	# Verificar si la nube ya cayó
	if nubes_caidas.get(nube, false):
		return  # Si ya cayó, no hacer nada

	# Si el jugador pasa la posición de la nube, hacerla caer
	if posicionPlayer.x >= posicionNube+10:
		var nuevaPos = nube.position.y + 100
		nubes_caidas[nube] = true  # Marcar la nube como caída

		var tween = get_tree().create_tween()
		tween.tween_property(nube, "position:y", nuevaPos, 0.5).set_trans(Tween.TRANS_LINEAR)
# -----------------------------------------------------------


# -----------------------------------------------------------
# Funcion game over del personaje 
func _on_personaje_barrera_baja_pierde():
	if vidas <= 1:
		get_tree().change_scene_to_file("res://Art/Menu/menu_reinicio.tscn")
	else:
		vidas -= 1
		Global.vidas_persistentes = vidas  # Guardar el valor antes de recargar
		contadorVida.text = str(vidas)
		# Recargar la escena actual
		get_tree().reload_current_scene()
# -----------------------------------------------------------
