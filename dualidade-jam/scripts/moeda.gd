extends Area2D

@onready var player = $"../CharacterBody2D"

func _on_body_entered(body):
	GlobalData.quantMoeda += 1
	
	queue_free()
	
