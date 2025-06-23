extends Area2D

@export var targets: Array[StaticBody2D]
@onready var player_node = $"../../CharacterBody2D"

var player_in_range = false
var ativada = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node:
		player_node.connect("collided_with_object", Callable(self, "_on_player_interacted_with_object"))
	else:
		print("ALAVANCA ERRO: Player não encontrado no grupo 'player' para conectar o sinal.")

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entrou na área da Alavanca: ", name)

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player_in_range = false
		print("Player saiu da área da Alavanca: ", name)

func interact_with_player(body_that_collided):
	if player_in_range and player_node.armUnlocked:
		print("Alavanca '" + name + "' detectou interação do Player.")
		$AudioStreamPlayer2D.play()
		scale.x *= -1
		for target in targets:
			target.visible = not target.visible
			target.get_child(0).disabled = not target.get_child(0).disabled
			print(target.visible)
			print(target.get_child(0).disabled)
