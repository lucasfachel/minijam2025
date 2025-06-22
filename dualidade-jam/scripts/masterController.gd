extends Node2D

@onready var label: Label = $CanvasLayer/Label
@onready var shopWindow = $ShopWindow
@onready var player = $CharacterBody2D

func _process(delta: float) -> void:
	label.text = str(GlobalData.quantMoeda)

func openShop():
	shopWindow.visible = true

func closeShop():
	shopWindow.visible = false
	
func unlockLegs():
	player.jumpUnlocked = true
	
func unlockEyes():
	player.get_child(2).visible = false
