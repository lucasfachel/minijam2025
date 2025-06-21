extends Node2D

@onready var label: Label = $CanvasLayer/Label
@onready var shopWindow = $Panel

func _process(delta: float) -> void:
	label.text = str(GlobalData.quantMoeda)

func openShop():
	shopWindow.visible = true

func closeShop():
	shopWindow.visible = false
