extends Area2D

@onready var label = $Label
@onready var master = $".."

var ativo = false

#inventario loja
@onready var pernas = $"../ShopWindow/Pernas"
@onready var olhos = $"../ShopWindow/Olhos"
@onready var player = $"../CharacterBody2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#para cada item da loja faça isso
	pernas.pressed.connect(Callable(self, "compra").bind(1))
	olhos.pressed.connect(Callable(self, "compra").bind(2))
	
	var player_node = player
	label.visible = false
	
	if player_node:
		player_node.connect("collided_with_object", interact_with_player)
		print("Objeto '" + name + "' conectado ao sinal de interação do Player.")
	else:
		print("ERRO: Objeto '" + name + "' não encontrou o Player para conectar o sinal. O Player está no grupo 'player'?")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	label.visible = true
	ativo = true
	print("trin tlin")

func _on_body_exited(body):
	label.visible = false
	ativo = false
	master.closeShop()

func interact_with_player(body_that_collided):
	if ativo:
		print("Player interagiu com ESTE objeto: ", name)
		master.openShop()

func compra(item):
	match item:
		1: 
			master.unlockLegs()
			pernas.get_child(0).visible = false
			pernas.get_child(1).visible = true
		2: 
			master.unlockEyes()
			olhos.get_child(0).visible = false
			olhos.get_child(1).visible = true
		3: pass
