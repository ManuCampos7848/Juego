extends Node

# Variables de personalización
var skin: String = ""
var cabello: String = ""
var sombrero: String = ""
var ropa: String = ""

# Ruta del archivo de guardado
const SAVE_PATH = "user://personalizacion_save.json"

func guardar_personalizacion():
	var datos = {
		"skin": skin,
		"cabello": cabello,
		"sombrero": sombrero,
		"ropa": ropa
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(datos))
		file.close()
		print("Datos guardados en:", SAVE_PATH)
	else:
		print("Error al guardar")

func cargar_personalizacion():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var contenido = file.get_as_text()
		var datos = JSON.parse_string(contenido)
		file.close()
		
		if datos:
			skin = datos.get("skin", "")
			cabello = datos.get("cabello", "")
			sombrero = datos.get("sombrero", "")
			ropa = datos.get("ropa", "")
			print("Datos cargados desde archivo")
			return true
	print("No hay datos guardados")
	return false
