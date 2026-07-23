extends Node

var u = 1
var ingredient_texs  = []

func _ready():
	randomize()
	var ingredient_paths = ["ingredient_worm.PNG"]
	for i in ingredient_paths:
		var im = Image.load_from_file("res://Assets/Textures/" + i)
		ingredient_texs.append(ImageTexture.create_from_image(im))
	
