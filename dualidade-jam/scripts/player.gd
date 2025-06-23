extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

signal collided_with_object(body)
var flipDirection = 1 #1 - Padrao // -1 - Invertido
var isJumping = false

var walkUnlocked = false
var jumpUnlocked = false
var eyeUnlocked = false
var armUnlocked = false
var flipUnlocked = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if flipDirection == 1:
			velocity += get_gravity() * delta 
		elif flipDirection == -1:
			velocity -= get_gravity() * delta
	
		
	if isJumping:
		animator.play("jump")
		if is_on_floor(): isJumping = false
	
	if Input.is_action_just_pressed("interact"):
		var interactable_nodes = get_tree().get_nodes_in_group("interactables")
		for node in interactable_nodes:
			if node.has_method("interact_with_player"):
				node.interact_with_player(self)
			else:
				print(node.name, " no grupo 'interactables' não possui o método 'interact_with_player'.")

	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and jumpUnlocked:
		if flipDirection == 1:
			velocity.y = JUMP_VELOCITY
			isJumping = true
		elif flipDirection == -1:
			velocity.y = -1 * JUMP_VELOCITY
			isJumping = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_l", "move_r")
	if walkUnlocked:
		if direction:
			velocity.x = direction * SPEED
			if not isJumping: animator.play("run")
			animator.flip_h = direction * flipDirection < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if not isJumping: animator.play("idle")
	
	move_and_slide()
	var push_threshold_velocity: float = 100.0 
	var push_force: float = 500.0
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collided_body = collision.get_collider()

		if collided_body is RigidBody2D: # Verifica se colidiu com um RigidBody2D
			var rigid_body = collided_body

			# Determinar a direção do empurrão
			# Se o Player está se movendo, empurra na direção da velocidade X do Player.
			var push_direction = Vector2.ZERO
			if abs(velocity.x) > push_threshold_velocity: # Player se movendo horizontalmente?
				push_direction.x = sign(velocity.x) # Empurra na direção do movimento X do Player
			elif abs(velocity.y) > push_threshold_velocity: # Player se movendo verticalmente? (para empurrar para cima/baixo)
				push_direction.y = sign(velocity.y) # Empurra na direção do movimento Y do Player
			else:
				# Se o Player está parado, mas encostado, empurra da posição do Player para a caixa
				push_direction = (rigid_body.global_position - global_position).normalized()
				# Opcional: Para manter empurrão puramente horizontal/vertical
				if abs(push_direction.x) > abs(push_direction.y):
					push_direction.y = 0
				else:
					push_direction.x = 0
				push_direction = push_direction.normalized()

			# Aplicar força contínua (mais suave que impulso em _physics_process)
			if push_direction != Vector2.ZERO:
				rigid_body.apply_central_force(push_direction * push_force)
				# Opcional: para debug
				# print("Empurrando ", rigid_body.name, " na direção: ", push_direction, " com força: ", push_force)
