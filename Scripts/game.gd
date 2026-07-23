extends Node2D

@onready var camera = $Camera2D
@onready var board  = $Board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_board_pos(pos):
	return (pos -  get_viewport().get_visible_rect().size/2) / camera.zoom - board.position

func _input(event):
	if event is InputEventMouseButton:
		print("game,", get_board_pos(event.position))
