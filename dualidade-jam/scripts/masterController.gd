extends Node2D

@onready var label: Label = $CanvasLayer/Label
@onready var shopWindow = $Camera2D/ShopWindow
@onready var player = $CharacterBody2D

func _process(delta: float) -> void:
	label.text = str(GlobalData.quantMoeda)

func openShop():
	shopWindow.visible = true

func closeShop():
	shopWindow.visible = false
	
func unlockLegs():
	player.walkUnlocked = true
	
func unlockEyes():
	player.get_child(2).visible = false

func unlockJump():
	player.jumpUnlocked = true
	
func unlockSoul():
	player.flipUnlocked = true

func unlockArm():
	player.armUnlocked = true

func end():
	get_tree().change_scene_to_file("res://scenes/end.tscn")

func _on_audio_stream_player_2d_finished() -> void:
	$AudioStreamPlayer2D.play()
