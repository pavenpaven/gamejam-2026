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

func get_tile_pos(ingredient, pos):
	var points = []
	for i in Globals.ingredient_structure[ingredient.type]:
		# We rotate the points in the structure around origo
		for k in range(ingredient.rot):
			i = [-i[1], i[0]]
		points.append(i)

	var minx = 100
	var miny = 100
	for i in points:
		# we find the minimum x, and y cords.
		minx = min(i[0], minx)
		miny = min(i[1], miny)

	var out = []
	for i in points:
		out.append(pos + Vector2(i[0], i[1]) - Vector2(minx, miny))
	return out
			
func drop(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	if pos.x > 0 && pos.x < board.width && pos.y > 0 && pos.y < board.width:
		var center = ingredient.centroid() 
		ingredient.onboard = true
		print(pos - center)
		ingredient.position = (round(pos + center - Vector2(0.5,0.5)) + Vector2(0.5, 0.5) - center) * board.tilesz + board.position # roundy fuckery

#"		var new_center = Globals.midpoint(points)
		var points = get_tile_pos(ingredient, round(pos - center - Vector2(0.5,0.5)))
		for i in points:
			if (i.y >= board.height || i.x >= board.width || i.x < 0 || i.y < 0) || board.tiles[i.y][i.x] != -1:
				ingredient.onboard = false
				ingredient.position = ingredient.origin
				return

		for i in points:
			board.tiles[i.y][i.x] = ingredient.type

		for i in board.tiles:
			print(i)
		ingredient.putdownsfx.play()
			
	else:
		ingredient.onboard = false

func grab(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	var center = ingredient.centroid()
	var points = get_tile_pos(ingredient, round(pos - center - Vector2(0.5,0.5)))
	for i in points:
		board.tiles[i.y][i.x] = -1

func get_real_pos(pos):
	return (pos - get_viewport().get_visible_rect().size/2) / camera.zoom

func get_board_pos(pos):
	return (get_real_pos(pos) - board.position) / board.tilesz

func _input(event):
	if event is InputEventMouseButton:
		pass
