# Global.gd
extends Node

# Variables de personalización con valores por defecto
var skin_seleccionada: int = 0
var sombrero_seleccionado: int = -1  # -1 significa ninguno
var cabello_seleccionado: int = -1
var ropa_seleccionada: int = -1

const SAVE_PATH = "user://personalizacion.save"

func _ready() -> void:
	# Cargar automáticamente al iniciar el juego
	cargar_datos_guardados()

func guardar_personalizacion():
	var datos = {
		"version": 1,
		"skin": skin_seleccionada,
		"sombrero": sombrero_seleccionado,
		"cabello": cabello_seleccionado,
		"ropa": ropa_seleccionada,
		"fecha_guardado": Time.get_datetime_string_from_system()
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(datos)
		file.close()
		print("✅ Personalización guardada en disco")
		print("   Skin: ", skin_seleccionada)
		print("   Cabello: ", cabello_seleccionado)
		print("   Sombrero: ", sombrero_seleccionado)
		print("   Ropa: ", ropa_seleccionada)
	else:
		print("❌ Error al guardar: ", FileAccess.get_open_error())

func cargar_datos_guardados():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var datos = file.get_var()
			file.close()
			
			if datos is Dictionary:
				skin_seleccionada = datos.get("skin", 0)
				sombrero_seleccionado = datos.get("sombrero", -1)
				cabello_seleccionado = datos.get("cabello", -1)
				ropa_seleccionada = datos.get("ropa", -1)
				print("📂 Datos de personalización cargados")
				print("   Skin: ", skin_seleccionada)
				print("   Cabello: ", cabello_seleccionado)
				print("   Sombrero: ", sombrero_seleccionado)
				print("   Ropa: ", ropa_seleccionada)
			else:
				print("⚠️ Formato de datos inválido")
		else:
			print("❌ Error al abrir archivo de guardado")
	else:
		print("📝 No hay datos guardados, usando valores por defecto")

# Función para resetear a valores por defecto (opcional)
func resetear_personalizacion():
	skin_seleccionada = 0
	sombrero_seleccionado = -1
	cabello_seleccionado = -1
	ropa_seleccionada = -1
	guardar_personalizacion()
