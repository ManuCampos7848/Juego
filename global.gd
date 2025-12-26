extends Node



# -----------------------------------------------------------
# Variables de vida
var vidas_persistentes = 3
# Sistema de sombreros
var sombrero_seleccionado = 1  # Valor por defecto: sombrero 1
var sombreroLateralEquivalente = 1

const RUTA_SOMBREROS_NORMALES = "res://Art/Personalizacion/Sombreros/"
const RUTA_SOMBREROS_LATERALES = "res://Art/Personalizacion/Sombreros/SombrerosLateral/"


#--------------------------------
# Implementacion del sistema de sobreros combinados
var esSombreroCombinado = false
var numeroSombreroCombinado = 0
#--------------------------------


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
var listaFront = []
var listaRigth = []
var listaWalkD = []
var listaWalkI = []
func save_settings():
	var config = ConfigFile.new()
	config.set_value("player", "vidas", vidas_persistentes)
	config.set_value("customization", "sombrero", sombrero_seleccionado)
	config.set_value("customization", "sombrero_lateral", sombreroLateralEquivalente)
	
	
	#--------------------------------
	# Nuevos datos para sombreros combinados
	config.set_value("customization", "es_sombrero_combinado", esSombreroCombinado)
	config.set_value("customization", "numero_sombrero_combinado", numeroSombreroCombinado)
	#--------------------------------
	
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("user://config"):
		dir.make_dir("user://config")
	
	var error = config.save("user://config/game_settings.cfg")
	#--------------------------------
	# print("Guardando - Combinado: ", esSombreroCombinado, " | Número: ", numeroSombreroCombinado)
	#--------------------------------
	
	config.set_value("textures", "front", _save_texture_array(listaFront))
	config.set_value("textures", "right", _save_texture_array(listaRigth))
	config.set_value("textures", "walkD", _save_texture_array(listaWalkD))
	config.set_value("textures", "walkI", _save_texture_array(listaWalkI))
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
		vidas_persistentes = config.get_value("player", "vidas", 5)
		sombrero_seleccionado = config.get_value("customization", "sombrero", 1)
		sombreroLateralEquivalente = config.get_value("customization", "sombrero_lateral", 1)
		
		#--------------------------------
		# Nuevos datos para sombreros combinados
		esSombreroCombinado = config.get_value("customization", "es_sombrero_combinado", false)
		numeroSombreroCombinado = config.get_value("customization", "numero_sombrero_combinado", 0)
		
		#--------------------------------
		
		listaFront = _load_texture_array(config.get_value("textures", "front", []))
		listaRigth = _load_texture_array(config.get_value("textures", "right", []))
		listaWalkD = _load_texture_array(config.get_value("textures", "walkD", []))
		listaWalkI = _load_texture_array(config.get_value("textures", "walkI", []))

	else:
		printerr("Error al cargar configuración: ", err)
	print("Cargando - Combinado: ", esSombreroCombinado, " | Número: ", numeroSombreroCombinado)
# ------------------------------------------------------------------------

func _save_texture_array(texture_array: Array) -> Array:
	var paths = []
	for texture in texture_array:
		if texture != null:
			paths.append(texture.resource_path)
		else:
			paths.append("")
	return paths

func _load_texture_array(path_array: Array) -> Array:
	var textures = []
	for path in path_array:
		if path != "":
			textures.append(load(path))
		else:
			textures.append(null)
	return textures
