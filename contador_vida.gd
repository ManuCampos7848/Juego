extends CanvasLayer


# Called when the node enters the scene tree for the first time.
# Inicia la animacion del personaje caminado arriba a la derecha
func _ready():
	$AnimatedSprite2D.play("walk")
	pass # Replace with function body.
# --------------------------------------------------
