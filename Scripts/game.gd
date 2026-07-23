extends Node2D

@onready var camera      = $Camera2D
@onready var board       = $Board
@onready var ingredients = [$Ingredient, $Ingredient2, $Ingredient3, $Ingredient4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ingredient in ingredients:
		if ingredient.grabbed:
			ingredient.position = get_real_pos(get_viewport().get_mouse_position()) + ingredient.grab_vec
		
func drop(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	if pos.x > 0 && pos.x < board.width && pos.y > 0 && pos.y < board.width:
		ingredient.onboard = true
		print(ingredient.centroid())
		print(pos - ingredient.centroid())
		ingredient.position = (round(pos + ingredient.centroid() - Vector2(0.5,0.5)) + Vector2(0.5, 0.5) - ingredient.centroid()) * board.tilesz + board.position
		
	else:
		ingredient.onboard = false
		
	
func get_real_pos(pos):
	return (pos - get_viewport().get_visible_rect().size/2) / camera.zoom

func get_board_pos(pos):
	return (get_real_pos(pos) - board.position) / board.tilesz

func _input(event):
	if event is InputEventMouseButton:
		pass
