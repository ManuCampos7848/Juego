extends CharacterBody2D

# -----------------------------------------------------------
# Señales
signal barreraBajaPierde
signal caer
# -----------------------------------------------------------


# -----------------------------------------------------------
# Variables de velocidad y de caida
const SPEED = 180.0
const JUMP_VELOCITY = -178.0
# -----------------------------------------------------------



# -----------------------------------------------------------
# Fisica (gravedad) del personaje
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# -----------------------------------------------------------



# -----------------------------------------------------------
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Update animation based on velocity.
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = true

	move_and_slide()

func _on_area_2d_body_entered(body):
	
	if body.name == "Perder":
		barreraBajaPierde.emit()
