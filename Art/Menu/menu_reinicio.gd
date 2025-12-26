extends Control

# -----------------------------------------------------------
# Metodo que reinicia el nivel mundo #1
func _on_button_pressed():
	Global.vidas_persistentes = 3
	get_tree().change_scene_to_file("res://mundo.tscn")
# -----------------------------------------------------------


func _on_button_2_pressed():
	Global.vidas_persistentes = 3
	get_tree().change_scene_to_file("res://Art/Menu/menu_inicio.tscn")
