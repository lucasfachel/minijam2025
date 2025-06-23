extends Area2D

@onready var player = $"../CharacterBody2D"
@onready var audio = $AudioStreamPlayer2D
var ativo = true

func _on_body_entered(body):
	if ativo:
		ativo = false
		GlobalData.quantMoeda += 1
		visible = false
		audio.play()
		audio.finished.connect(queue_free)
