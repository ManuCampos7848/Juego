extends GPUParticles2D

@export var star_texture: Texture2D
@export var min_speed: float = 80.0
@export var max_speed: float = 120.0
@export var spawn_area_width: float = 400.0

func _ready():
	setup_particles()

func setup_particles():
	# Configuración básica
	emitting = true
	amount = 150
	lifetime = 4.0
	explosiveness = 0.0
	one_shot = false
	
	# Posicionar en la parte inferior de la pantalla
	var viewport_size = get_viewport_rect().size
	position = Vector2(viewport_size.x / 2, viewport_size.y + 50)
	
	# Configurar material de proceso
	var process_material = ParticleProcessMaterial.new()
	
	# Dirección hacia arriba con dispersión
	process_material.direction = Vector3(0, -1, 0)
	process_material.spread = 45.0
	process_material.initial_velocity_min = min_speed
	process_material.initial_velocity_max = max_speed
	
	# Gravedad suave
	process_material.gravity = Vector3(0, 15.0, 0)
	
	# Tiempo de vida
	process_material.lifetime = lifetime
	process_material.lifetime_randomness = 0.4
	
	# Escala
	process_material.scale_min = 0.5
	process_material.scale_max = 1.2
	
	# Color con gradiente para desvanecimiento
	var gradient = Gradient.new()
	gradient.colors = PackedColorArray([
		Color(1, 1, 1, 0),    # Transparente al inicio
		Color(1, 1, 1, 1),    # Completamente visible
		Color(1, 1, 1, 0)     # Transparente al final
	])
	gradient.offsets = PackedFloat32Array([0.0, 0.3, 1.0])
	process_material.color_ramp = gradient
	
	self.process_material = process_material
	
	# Asignar textura si existe
	if star_texture:
		self.texture = star_texture

func update_emitter_size(viewport_size: Vector2):
	position = Vector2(viewport_size.x / 2, viewport_size.y + 50)
