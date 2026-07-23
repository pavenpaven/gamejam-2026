extends Node2D

@export  var width  = 8
@export  var height = 8
@export  var tilesz = 16
@onready var tilemap = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap.tile_set.tile_size = Vector2(tilesz, tilesz)
	for i in range(width):
		for j in range(height):
			tilemap.set_cell(Vector2(i,j), 0, Vector2(0,0))

func _input(event):
	if event is InputEventMouseButton:
		print(event.position)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
