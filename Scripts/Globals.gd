extends Node

var ingredient_texs      = []
var ingredient_back_texs = []

var ingredient_paths = [
	"ingredient_worm.PNG",
	"ingrediens_coral.PNG",
	"ingrediens_jellyfish.PNG",
	"ingrediens_seaweed.PNG",
	"ingrediens_starfish.PNG",
	"ingrediens_tomato.PNG",
	"ingrediens_snail.PNG",
	"ingrediens_straight_seaweed.PNG"]
var ingredient_paths_background = [
	"ingredient_worm_background.PNG",
	"ingrediens_coral_background.PNG",
	"ingrediens_jellyfish_background.PNG",
	"ingrediens_seaweed_background.PNG",
	"ingrediens_starfish_background.PNG",
	"ingrediens_tomato_background.PNG",
	"ingrediens_snail_background.PNG",
	"ingrediens_straight_seaweed_background.PNG"]

var ingredient_structure =[
	[[1,0],[2,0],[0,1],[1,1]], ## worm
	[[1,0],[0,1],[1,1],[2,1]], ## coral
	[[0,0],[1,0],[2,0],[0,1],[2,1]], ## jellyfish
	[[0,0],[1,0],[0,1]], ## seaweed
	[[0,0],[1,0],[0,1],[1,1]], ## starfish
	[[0,0],[1,0]], ## tomato
	[[0,0],[1,0],[0,1],[1,1]], ## snail
	[[0,0],[1,0],[2,0]] ## Straight seaweed
	]

# blue 0 red 1 green 2 brown 3

var ingredient_color  = [
	3, # worm
	1, # coral
	0, # jelly
	2, # seaweed
	0, # starfish
	1, # tomat
	3, # snail
	2  # straight seaweed
	]

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
		maxy = max(i[1], maxy)
	return Vector2(maxx - minx, maxy - miny) / 2
