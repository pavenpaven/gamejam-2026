extends Node2D

@export  var width  = 6
@export  var height = 6
@export  var tilesz = 16
@onready var tilemap = $TileMapLayer
@onready var view = $SubViewport

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap.tile_set.tile_size = Vector2(tilesz, tilesz)
	reset_tiles()

func reset_tiles():
	tiles = []
	for i in range(width):
		tiles.append([])
		for j in range(height):
			tiles[-1].append(-1)
			tilemap.set_cell(Vector2(i,j), 0, Vector2(0,0))
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func col(type):
	if type == -1:
		return -1
	return Globals.ingredient_color[type]

func border_between(col1, col2): # return the number of instances that the colors col1 and col2 neighbour
	var lengt = 0
	for i in range(width):
		var previous = -1
		for j in range(height):
			var current = tiles[j][i]
			if ((col(current) == col1 && col(previous) == col2)
				|| (col(current) == col2 && col(previous) == col1)):
				lengt += 1
			previous = current

	for j in range(height):
		var previous = -1
		for i in range(width):
			var current = tiles[j][i]
			if ((col(current) == col1 && col(previous) == col2)
				|| (col(current) == col2 && col(previous) == col1)):
				lengt += 1
			previous = current

	return lengt
