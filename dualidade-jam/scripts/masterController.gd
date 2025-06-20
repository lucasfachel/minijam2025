extends Node2D

@onready var label: Label = $CanvasLayer/Label

func _process(delta: float) -> void:
	label.text = str(GlobalData.quantMoeda)
