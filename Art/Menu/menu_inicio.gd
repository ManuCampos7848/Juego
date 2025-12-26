extends Control

# -----------------------------------------------------------
# Metodo que incia el Mundo #1
func _on_iniciar_pressed():
	print("DEBUG: Botón presionado")
	$Iniciar.disabled = true
	
	# Iniciar fade-out
	fade_overlay.show()
	fade_overlay.color = Color(0, 0, 0, 0)  # Negro transparente
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	fade_out_timer = 0.0
	fade_out_in_progress = true

func start_fade_out():
	# Preparar el overlay para fade-out
	fade_overlay.show()
	fade_out_timer = 0.0
	fade_out_in_progress = true
	
	# Configurar para que empiece transparente y termine opaco
	fade_overlay.color.a = 0.0
# -----------------------------------------------------------

var interval := 0.2  # 20 veces por segundo
var timer := 0.0
var fade_timer := 0.0
var fade_duration := 1.5  # 1.5 segundos de fade-in
var fade_completed := false
var fade_out_timer := 0.0
var fade_out_duration := 0.8  # Duración del fade-out
var fade_out_in_progress := false

@onready var sprite := $PresStart
@onready var fade_overlay = ColorRect.new()

func _ready():
	# Configurar el fade overlay (solo estas 3 líneas nuevas)
	fade_overlay.color = Color.BLACK
	fade_overlay.size = get_viewport().get_visible_rect().size
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_STOP  # Esto bloquea clics
	add_child(fade_overlay)

func _process(delta):
	# Fade-in de la pantalla al inicio
	if !fade_completed and !fade_out_in_progress:
		fade_timer += delta
		var progress = fade_timer / fade_duration
		var alpha = 1.0 - clamp(progress, 0.0, 1.0)
		fade_overlay.color.a = alpha
		
		# Cuando termine el fade-in, ocultarlo completamente
		if fade_timer >= fade_duration:
			fade_completed = true
			fade_overlay.hide()  # Esto lo hace invisible y permite clics
	
	# Fade-out cuando se presiona el botón
	if fade_out_in_progress:
		fade_out_timer += delta
		var progress = fade_out_timer / fade_out_duration
		var alpha = clamp(progress, 0.0, 1.0)
		fade_overlay.color.a = alpha
		
		# Cuando termine el fade-out, cambiar de escena
		if fade_out_timer >= fade_out_duration:
			fade_out_in_progress = false
			print("DEBUG: Fade-out completado")
			get_tree().change_scene_to_file("res://Art/Menu/Menu Principal/menu_principal.tscn")
