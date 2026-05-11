extends CharacterBody2D

var velocidad = 75.0
var direccion = 1 # 1 derecha, -1 izquierda

@onready var sprite = $AnimatedSprite2D
@onready var detector = $DetectorSuelo # Asegúrate de que se llame así en la escena

func _physics_process(delta):
	# 1. Gravedad
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	# 2. Lógica de giro:
	# Si choca con pared O si el detector NO toca suelo (abismo o pinchos)
	if is_on_wall() or not detector.is_colliding():
		girar()

	# 3. Movimiento
	velocity.x = direccion * velocidad
	move_and_slide()
	
	# --- CONTROL DE ANIMACIÓN ---
	if velocity.x != 0:
		sprite.play("run")  # Ejecuta la animación "run" si se está moviendo
	else:
		sprite.play("idle") # Opcional: una animación de estar quieto
	# ----------------------------

func girar():
	direccion *= -1
	# Girar el sprite
	sprite.flip_h = !sprite.flip_h
	# IMPORTANTE: Mover el detector al otro lado
	detector.position.x *= -1


func _on_hitbox_body_entered(body: Node2D) -> void:
	# Verificamos si es el personaje
	if body.name == "Personaje":
		# Llamamos directamente a la función que ya escribiste en tu personaje
		# Esto activará el shader rojo y el timer de 0.5s sin reiniciar la música
		body._on_area_2d_body_entered(null)
