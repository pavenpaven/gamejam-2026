extends Node2D

var width  = 6
var height = 6
var tilesz = 16
@onready var tilemap = $TileMapLayer
@onready var view = $SubViewport

var borders = []

var tiles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vec = Vector2(16, 16)
	tilemap.tile_set.tile_size = vec
	width  = 6
	height = 6
	tilesz = 16
	reset_tiles()

func reset_tiles():
	tiles = []
	for i in range(width):
		tiles.append([])
		for j in range(height):
			tiles[-1].append(-1)
			tilemap.set_cell(Vector2(i,j), 0, Vector2(0,0))
	update_borders([])
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func col(type):
	if type == -1:
		return 4
	if type == -2:
		return -1
	return Globals.ingredient_color[type]

func update_borders(requests):
	for i in borders:
		i.queue_free()
		remove_child(i)
	borders = []

	for req in requests:
		if req["type"] in [0,1]:
			var col1 = req["cola"]
			var col2 = req["colb"]
			for i in range(width):
				var previous = -2
				for j in range(height):
					var current = tiles[j][i]
					if ((col(current) == col1 && col(previous) == col2)
						|| (col(current) == col2 && col(previous) == col1)):
						var sprite = Sprite2D.new()
						borders.append(sprite)
						if req["type"] == 0:
							sprite.texture = Globals.neigh_good_tex
						else:
							sprite.texture = Globals.neigh_bad_tex
						sprite.position = Vector2(16*i + 8, 16*j )
						sprite.rotation = PI/2
						add_child(sprite)
					previous = current

			for j in range(height):
				var previous = -2
				for i in range(width):
					var current = tiles[j][i]
					if ((col(current) == col1 && col(previous) == col2)
						|| (col(current) == col2 && col(previous) == col1)):
						var sprite = Sprite2D.new()
						borders.append(sprite)
						if req["type"] == 0:
							sprite.texture = Globals.neigh_good_tex
						else:
							sprite.texture = Globals.neigh_bad_tex
						sprite.position = Vector2(16*i, 16*j + 8)
						add_child(sprite)
					previous = current
				
				
				

func border_between(col1, col2): # return the number of instances that the colors col1 and col2 neighbour
	var lengt = 0
	for i in range(width):
		var previous = -2
		for j in range(height):
			var current = tiles[j][i]
			if ((col(current) == col1 && col(previous) == col2)
				|| (col(current) == col2 && col(previous) == col1)):
				lengt += 1
			previous = current

	for j in range(height):
		var previous = -2
		for i in range(width):
			var current = tiles[j][i]
			if ((col(current) == col1 && col(previous) == col2)
				|| (col(current) == col2 && col(previous) == col1)):
				lengt += 1
			previous = current

	return lengt
