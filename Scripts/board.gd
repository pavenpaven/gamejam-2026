extends Node2D


@export  var width  = 8
@export  var height = 8
@onready var area = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		print(event.position)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	print(Globals.ingredients)
