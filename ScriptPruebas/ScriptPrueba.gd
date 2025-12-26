extends Node

var totalSombreros = 8
var current_hat = 1

var sombreroEnLista = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	current_hat = GlobalPrueba.sombrero_seleccionado
	
	for i in range(1, totalSombreros + 1	):
		#print(get_node("Sombreros/Sombrero" + str(i)))
		var sombrero = get_node("Sombreros/Sombrero" + str(i))
		sombrero.visible = false
	
	get_node("Sombreros/Sombrero1").visible = true
	$CombinarSombrero.disabled = true
	
	if verificarDisponibilidad(current_hat):
		print("carolo")
		$CombinarSombrero.disabled = false
	else:
		$CombinarSombrero.disabled = true
	
func reiniciarSombreros():
	for i in range(1, totalSombreros + 1	):
		#print(get_node("Sombreros/Sombrero" + str(i)))
		var sombrero = get_node("Sombreros/Sombrero" + str(i))
		sombrero.visible = false
	GlobalPrueba.esSombreroCombinado = false
	GlobalPrueba.numeroSombreroCombinado = 0
	
func _on_Button_pressed():
	reiniciarSombreros()
	# Ocultar actual
	get_node("Sombreros/Sombrero" + str(current_hat)).visible = false
	
	# Cambiar sombrero
	current_hat = (current_hat % totalSombreros) + 1
	print("Cambiando a sombrero: ", current_hat)
	
	if verificarDisponibilidad(current_hat):
		print("carolo")
		$CombinarSombrero.disabled = false
	else:
		$CombinarSombrero.disabled = true
	# Mostrar nuevo
	get_node("Sombreros/Sombrero" + str(current_hat)).visible = true
	
	# Actualizar Global
	GlobalPrueba.sombrero_seleccionado = current_hat
	GlobalPrueba.save_settings()

func _on_iniciar_pressed():
	# Guardar solo una vez
	GlobalPrueba.sombrero_seleccionado = current_hat
	var save_result = Global.save_settings()
	
	if save_result == OK:
		get_tree().change_scene_to_file("res://ScriptPruebas/PlayerScenaPrueba.tscn")
	else:
		printerr("Error al guardar: ", save_result)
		# Muestra un mensaje de error al jugador si lo deseas


func verificarDisponibilidad(current_hat):
	
	match current_hat:
		1: return true
		6: return true
		

func _on_combinar_sombrero_pressed():

	match current_hat:
		
		1:
			get_node("Sombreros/Sombrero2").visible = true
			GlobalPrueba.esSombreroCombinado = true
			GlobalPrueba.numeroSombreroCombinado = 2
		# 2 con el 5
		6:
			get_node("Sombreros/Sombrero7").visible = true
			GlobalPrueba.esSombreroCombinado = true
			GlobalPrueba.numeroSombreroCombinado = 7
	
	# Guardar cambios después de combinar
	var save_result = GlobalPrueba.save_settings()
	if save_result != OK:
		printerr("Error al guardar sombrero combinado")
	pass # Replace with function body.
