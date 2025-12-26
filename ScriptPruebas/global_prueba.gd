extends Node



# -----------------------------------------------------------
# Variables de vida
var vidas_persistentes = 5
# Sistema de sombreros
var sombrero_seleccionado = 1  # Valor por defecto: sombrero 1
var sombreroLateralEquivalente = 1

const RUTA_SOMBREROS_NORMALES = "res://Art/Personalizacion/Sombreros/"
const RUTA_SOMBREROS_LATERALES = "res://Art/Personalizacion/Sombreros/SombrerosLateral/"
# -----------------------------------------------------------


# -----------------------------------------------------------
var esSombreroCombinado = false
var numeroSombreroCombinado = 0
# -----------------------------------------------------------




const SAVE_PATH = "res://game_settings.cfg"  # Cambiado a res:// para debugging


# -----------------------------------------------------------
func _ready():
	load_settings()
# -----------------------------------------------------------


# ------------------------------------------------------------------------
# Metodo que guarda valores en persistencia
'''
	Se llama este metodo cuando se pierde una vida o
	cuando se elige un sombrero de la lista, osea, se
	setean valores
'''
func save_settings():
	var config = ConfigFile.new()
	# Guardar datos existentes
	config.set_value("player", "vidas", vidas_persistentes)
	config.set_value("customization", "sombrero", sombrero_seleccionado)
	config.set_value("customization", "sombrero_lateral", sombreroLateralEquivalente)
	
	# Nuevos datos para sombreros combinados
	config.set_value("customization", "es_sombrero_combinado", esSombreroCombinado)
	config.set_value("customization", "numero_sombrero_combinado", numeroSombreroCombinado)
	
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://config"):
		dir.make_dir("user://config")
	
	var error = config.save("user://config/game_settings.cfg")
	print("Guardando - Combinado: ", esSombreroCombinado, " | Número: ", numeroSombreroCombinado)
	return error


# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
# Metodo que carga los datos de la persistencia
'''
	Cada que se reinicia el mundo (porque perdio el player),
	se llama este metodo para ver cuantas vidas le quedan y
	que sombrero fue el que escogio
'''
func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		# Cargar datos existentes
		vidas_persistentes = config.get_value("player", "vidas", 5)
		sombrero_seleccionado = config.get_value("customization", "sombrero", 1)
		sombreroLateralEquivalente = config.get_value("customization", "sombrero_lateral", 1)
		
		# Nuevos datos para sombreros combinados
		esSombreroCombinado = config.get_value("customization", "es_sombrero_combinado", false)
		numeroSombreroCombinado = config.get_value("customization", "numero_sombrero_combinado", 0)
	else:
		printerr("Error al cargar configuración: ", err)
	print("Cargando - Combinado: ", esSombreroCombinado, " | Número: ", numeroSombreroCombinado)

# ------------------------------------------------------------------------
