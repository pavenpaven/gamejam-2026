extends Node

var ingredient_texs      = []
var ingredient_back_texs = []

var ingredient_paths = ["ingredient_worm.PNG",
	"ingrediens_coral.PNG",
	"ingrediens_jellyfish.PNG",
	"ingrediens_seaweed.PNG",
	"ingrediens_starfish.PNG",
	"ingrediens_tomato.PNG"]
var ingredient_paths_background = ["ingredient_worm_background.PNG",
	"ingrediens_coral_background.PNG",
	"ingrediens_jellyfish_background.PNG",
	"ingrediens_seaweed_background.PNG",
	"ingrediens_starfish_background.PNG",
	"ingrediens_tomato_background.PNG"]

var ingredient_structure =[[[0,0],[1,0],[1,1],[2,1]],
	[[0,0],[1,0],[1,1],[2,1]],
	[[0,0],[0,1],[1,1],[2,1],[3,1],[3,0]],
	[[0,0],[0,1],[1,1]],
	[[0,0],[1,0],[1,1],[0,1]],
	[[0,0],[1,0],[1,1],[0,1]]]

func _ready():
	randomize()
	for i in ingredient_paths:
		var im = Image.load_from_file("res://Assets/Textures/" + i)
		ingredient_texs.append(ImageTexture.create_from_image(im))

	for i in ingredient_paths_background:
		var im = Image.load_from_file("res://Assets/Textures/" + i)
		ingredient_back_texs.append(ImageTexture.create_from_image(im))


func midpoint(points):
	var minx = 100
	var miny = 100
	var maxx = -100
	var maxy = -100
	for i in points:
		minx = min(i[0], minx)
		miny = min(i[1], miny)
		maxx = max(i[0], maxx)
		maxy = max(i[1], maxx)
	return Vector2(maxx - minx, maxy - miny) / 2
