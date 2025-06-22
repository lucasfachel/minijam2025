extends Area2D

@export var target_camera_position: Vector2 = Vector2(480, 810)

@export var camera_transition_speed: float = 0.3 # Tempo em segundos para a transição (mais longo = mais suave)

var is_player_in_zone = false # Flag para evitar múltiplas transições

func _ready():
	# Conecta o sinal body_entered() e body_exited() desta Area2D.
	# Certifique-se de que estas conexões são feitas (pode ser feito visualmente no editor também).
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	print("Zona de Câmera '" + name + "' pronta.")

func _on_body_entered(body: Node2D):
	# Verifica se o corpo que entrou é o Player (assumindo que o Player está no grupo "player")
	if body.is_in_group("player") and not is_player_in_zone:
		is_player_in_zone = true
		print("Player entrou na zona da câmera: ", name)
		
		# Encontra a câmera principal da cena.
		# Ajuste este caminho para onde sua câmera principal ESTÁ na árvore de cena.
		# Se ela for filha do nó Root (geralmente MainScene), o caminho é absoluto.
		var main_camera = get_tree().get_first_node_in_group("main_camera") 
		# OU var main_camera = get_node("/root/MainScene/MainCamera") # Substitua pelo caminho real
		# OU crie um grupo "main_camera" para sua câmera principal e use get_tree().get_first_node_in_group("main_camera")

		if main_camera and main_camera is Camera2D:
			# Cria um Tween para animar o movimento da câmera suavemente
			var tween = create_tween()
			tween.tween_property(main_camera, "global_position", target_camera_position, camera_transition_speed)
			tween.set_trans(Tween.TRANS_SINE) # Tipo de transição (ex: TRANS_SINE, TRANS_QUAD, TRANS_LINEAR)
			tween.set_ease(Tween.EASE_IN_OUT) # Easing (ex: EASE_IN_OUT, EASE_OUT)
			print("Iniciando transição da câmera para: ", target_camera_position)
		else:
			print("Erro: Câmera principal não encontrada ou não é uma Camera2D.")

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		is_player_in_zone = false
		print("Player saiu da zona da câmera: ", name)
		# Opcional: Se você quiser que a câmera retorne à tela anterior
		# quando o jogador sair desta zona, você precisaria de lógica
		# para determinar qual é a tela anterior e mover para lá.
		# Ou, mais comumente, você teria outra Area2D na próxima tela que
		# ativaria o movimento da câmera para essa nova tela.
