extends Control

# Variables de parpadeo
var blink_timer := 0.0
var blink_speed := 1.5  # Velocidad del parpadeo (ciclos por segundo)
var is_blinking := true

# Variables de fade
var interval := 0.2
var timer := 0.0
var fade_timer := 0.0
var fade_duration := 1.5
var fade_completed := false
var fade_out_timer := 0.0
var fade_out_duration := 0.8
var fade_out_in_progress := false

@onready var sprite := $PresStart
@onready var fade_overlay = ColorRect.new()

func _ready():
	# Configurar el fade overlay
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(fade_overlay)
	
	# Iniciar el parpadeo
	start_blinking()

func _process(delta):
	# Parpadeo del sprite
	if is_blinking:
		blink_timer += delta
		var alpha = (sin(blink_timer * blink_speed * PI * 2) + 1.0) * 0.5
		sprite.modulate.a = lerp(0.3, 1.0, alpha)  # Oscila entre 0.3 y 1.0 de opacidad
	
	# Fade-in de la pantalla al inicio
	if !fade_completed and !fade_out_in_progress:
		fade_timer += delta
		var progress = fade_timer / fade_duration
		var alpha = 1.0 - clamp(progress, 0.0, 1.0)
		fade_overlay.color.a = alpha
		
		if fade_timer >= fade_duration:
			fade_completed = true
			fade_overlay.hide()
	
	# Fade-out cuando se presiona el botón
	if fade_out_in_progress:
		fade_out_timer += delta
		var progress = fade_out_timer / fade_out_duration
		var alpha = clamp(progress, 0.0, 1.0)
		fade_overlay.color.a = alpha
		
		if fade_out_timer >= fade_out_duration:
			fade_out_in_progress = false
			is_blinking = false  # Detener el parpadeo
			print("DEBUG: Fade-out completado")
			get_tree().change_scene_to_file("res://Art/Menu/Menu Principal/menu_principal.tscn")

# Método para iniciar el parpadeo
func start_blinking():
	is_blinking = true
	blink_timer = 0.0

# Método para detener el parpadeo
func stop_blinking():
	is_blinking = false
	sprite.modulate.a = 1.0  # Restaurar opacidad completa

# -----------------------------------------------------------
# Método que inicia el Mundo #1
func _on_iniciar_pressed():
	print("DEBUG: Botón presionado")
	$Iniciar.disabled = true
	
	# Detener el parpadeo
	stop_blinking()
	
	# Iniciar fade-out
	fade_overlay.show()
	fade_overlay.color = Color(0, 0, 0, 0)
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	fade_out_timer = 0.0
	fade_out_in_progress = true
