extends StaticBody2D

@onready var collisionShape = $CollisionShape2D
@export var activated: = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = activated
	collisionShape.disabled = not activated


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
