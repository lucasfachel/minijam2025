extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

signal collided_with_object(body)
var flipDirection = 1 #1 - Padrao // -1 - Invertido
var isJumping = false

var jumpUnlocked = false


func _physics_process(delta: float) -> void:
	print(flipDirection)
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
	if direction:
		velocity.x = direction * SPEED
		if not isJumping: animator.play("run")
		animator.flip_h = direction * flipDirection < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not isJumping: animator.play("idle")
	
	move_and_slide()
