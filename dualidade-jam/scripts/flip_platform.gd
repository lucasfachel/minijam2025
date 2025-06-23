extends StaticBody2D

@onready var player = $"../../CharacterBody2D"
@onready var areaTop = $FlipAreaTop
@onready var areaBot = $FlipAreaBot

var ativoTop = false
var ativoBot = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	areaTop.body_entered.connect(_on_area_top_entered)
	areaTop.body_exited.connect(_on_area_top_exited)
	areaBot.body_entered.connect(_on_area_bot_entered)
	areaBot.body_exited.connect(_on_area_bot_exited)
	if player:
		player.connect("collided_with_object", interact_with_player)
		print("Objeto '" + name + "' conectado ao sinal de interação do Player.")
	else:
		print("ERRO: Objeto '" + name + "' não encontrou o Player para conectar o sinal.")
		
	ativoBot = false
	ativoTop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_top_entered(body) -> void:
	ativoTop = true
func _on_area_top_exited(body) -> void:
	ativoTop = false
func _on_area_bot_entered(body) -> void:
	ativoBot = true
func _on_area_bot_exited(body) -> void:
	ativoBot = false

func interact_with_player(body_that_collided):
	if ((ativoTop and player.flipDirection == 1) or (ativoBot and player.flipDirection == -1)) and player.flipUnlocked:
		flipPlayer()
		print("Player interagiu com ESTE objeto: ", name)

func flipPlayer():
	player.flipDirection *= -1
	player.up_direction *= -1
	player.scale *= -1
