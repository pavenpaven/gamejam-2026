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

func _ready():
	randomize()
	for i in ingredient_paths:
		var im = Image.load_from_file("res://Assets/Textures/" + i)
		ingredient_texs.append(ImageTexture.create_from_image(im))

	for i in ingredient_paths_background:
		var im = Image.load_from_file("res://Assets/Textures/" + i)
		ingredient_back_texs.append(ImageTexture.create_from_image(im))
