extends Node2D

@onready var camera      = $Camera2D
@onready var board       = $Board
@onready var ingredients = [$Ingredient]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ingredient in ingredients:
		if ingredient.grabbed:
			ingredient.position = get_real_pos(get_viewport().get_mouse_position())
		
func drop(ingredient):
	var pos = get_board_pos(get_viewport().get_mouse_position())
	if pos.x > 0 && pos.x < board.width && pos.y > 0 && pos.y < board.width:
		Globals.midpoint(Globals.ingredient_structure[ingredient.type])
	
func get_real_pos(pos):
	return (pos - get_viewport().get_visible_rect().size/2) / camera.zoom

func get_board_pos(pos):
	return (get_real_pos(pos) - board.position) / board.tilesz

func _input(event):
	if event is InputEventMouseButton:
		pass
