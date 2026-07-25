extends Node

var rounds_done = 0

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

# blue 0 red 1 green 2 brown 3 air 4

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

var separate_symbol_tex
var neigh_good_tex
var neigh_bad_tex
var color_symbol_texs = []

var color_symbols_paths = [
	"dialogue_blue.PNG",
	"dialogue_red.PNG",
	"dialogue_green.PNG",
	"dialogue_brown.PNG",
	"dialogue_empty.PNG"
	]

var num_texs = []
var num_paths = [
	"texture_0.PNG",
	"texture_1.PNG",
	"texture_2.PNG",
	"texture_3.PNG",
	"texture_4.PNG",
	]

var x_tex
var slash_tex

func _ready():
	randomize()
	for i in ingredient_paths:
		var im : Texture2D = load("res://Assets/Textures/" + i)
		ingredient_texs.append(im)

	for i in ingredient_paths_background:
		var im = load("res://Assets/Textures/" + i)
		ingredient_back_texs.append(im)

	for i in color_symbols_paths:
		var im = load("res://Assets/Textures/" + i)
		color_symbol_texs.append(im)

	for i in num_paths:
		var im = load("res://Assets/Textures/" + i)
		num_texs.append(im)

	
	x_tex               = load("res://Assets/Textures/texture_x.PNG")
	slash_tex           = load("res://Assets/Textures/texture_slash.PNG")
	neigh_good_tex      = load("res://Assets/Textures/show_neighbor_good.PNG")
	neigh_bad_tex       = load("res://Assets/Textures/show_neighbor_bad.PNG")
	separate_symbol_tex = load("res://Assets/Textures/dialogue_seperate.PNG")

	


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
