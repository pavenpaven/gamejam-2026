extends Node2D

@onready var camera      = $Camera2D
@onready var board       = $Board
@onready var buttonclick = $Buttonclicked
@onready var button      = $Sprite2D
@onready var timertext   = $Timertext
@onready var timer       = $Timer
@onready var ingredients = [
	$Ingredient, $Ingredient2, $Ingredient3
	, $Ingredient4, $Ingredient5, $Ingredient6
	, $Ingredient7, $Ingredient8]


var can_serve = false
var characters = []
var challange

var timer_length = 60
var NUM_REQS = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_challange()
	print_challange()
	update_faces()

func satisfied(req):
	if req["type"] == 0:
		return board.border_between(req["cola"], req["colb"]) > 2
	if req["type"] == 1:
		return board.border_between(req["cola"], req["colb"]) == 0
	return false
	
	
func update_can_serve():
	var all_ingredients_onboard = true
	for i in ingredients:
		if not i.onboard:
			all_ingredients_onboard = false

	if all_ingredients_onboard:
		var all_reqs_satisfied = true
		for req in challange:
			if not satisfied(req):
				all_reqs_satisfied = false
		can_serve = all_reqs_satisfied
	else:
		can_serve = false



func random_request():
	var type = randi() % 2
	if type == 1:
		type = randi() % 2

	if type == 0:
		var cola = randi() % 4
		var colb = randi() % 3
		if colb >= cola: # this is to enshure that they are distinct
			colb += 1
		return {"type":0, "cola": cola, "colb": colb}
	if type == 1:
		var cola = randi() % 4
		var colb = randi() % 3
		if colb >= cola:
			colb += 1
		return {"type":1, "cola": cola, "colb": colb}
	

func incompatible(req1, req2):
	if req1["type"] == 0 || req1["type"] == 1:
		return ((req1["cola"] == req2["cola"] && req1["colb"] == req2["colb"])
			||  (req1["cola"] == req2["colb"] && req1["colb"] == req2["cola"]))
	print("warning missing incompatiblility check")
	return true
	
	
func generate_challange():
	timer.start(timer_length)
	timer_length = timer_length - timer_length * 0.1
	challange = []
	for i in characters:
		remove_child(i)
		i.queue_free()
	characters = []
	var character_scene = preload("res://Scenes/character.tscn")
	
	var count = 0
	while count < NUM_REQS: # theres an infite loop here if you set the count bound to high
		var req = random_request()
		var allowed = true
		for j in challange:
			if incompatible(req, j):
				allowed = false
				
		if allowed:
			challange.append(req)
			count += 1

	count = 0
	while count < NUM_REQS:
		var char_id = randi() % 8
		var unique = true
		for i in characters:
			unique = unique && (not i.character_id == char_id)
		if unique:
			var inst = character_scene.instantiate()
			inst.character_id = char_id
			inst.position = Vector2(-155 + 100 * count, -65)
			add_child(inst)
			characters.append(inst)
			inst.set_textbox(challange[count])
			count += 1

	
func col_string(col):
	return ["blue", "red", "green", "brown"][col]

func print_challange():
	for i in challange:
		if i["type"] == 0:
			print("Color ", col_string(i["cola"]) , " next to ", col_string(i["colb"]))
		if i["type"] == 1:
			print("Color ", col_string(i["cola"]) , " not next to ", col_string(i["colb"]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left = int(round(timer.time_left))
	
	timertext.text = str(time_left) + "s left"

	if can_serve:
		button.z_index = 0
	else:
		button.z_index = -1
	
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

func update_faces():
	update_can_serve()
	for i in range(len(challange)):
		var req = challange[i]
		if req["type"] == 0:
			if satisfied(req):
				var chara = characters[i]
				chara.sprite.animation = "happy_" + str(chara.character_id)
				chara.face.z_index = 1
			else:
				var chara = characters[i]
				chara.sprite.animation = "normal_" + str(chara.character_id)
				chara.face.z_index = -1
		if req["type"] == 1:
			if satisfied(req):
				var chara = characters[i]
				chara.sprite.animation = "happy_" + str(chara.character_id)
				chara.face.z_index = 1
			else:
				var chara = characters[i]
				chara.sprite.animation = "angry_" + str(chara.character_id)
				chara.face.z_index = -1

func drop(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	if pos.x > 0 && pos.x < board.width && pos.y > 0 && pos.y < board.width:
		var center = ingredient.centroid() 
		ingredient.onboard = true
		ingredient.position = (round(pos + center - Vector2(0.5,0.5)) + Vector2(0.5, 0.5) - center) * board.tilesz + board.position # roundy fuckery

#"		var new_center = Globals.midpoint(points)
		var points = get_tile_pos(ingredient, round(pos - center - Vector2(0.5,0.5)))
		for i in points:
			if (i.y >= board.height || i.x >= board.width || i.x < 0 || i.y < 0) || board.tiles[i.y][i.x] != -1:
				ingredient.reset()
				return

		for i in points:
			board.tiles[i.y][i.x] = ingredient.type

		ingredient.putdownsfx.play()
		board.update_borders(challange)
		update_faces()
	else:
		ingredient.reset()

func grab(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	var center = ingredient.centroid()
	var points = get_tile_pos(ingredient, round(pos - center - Vector2(0.5,0.5)))
	for i in points:
		board.tiles[i.y][i.x] = -1

	board.update_borders(challange)
	ingredient.onboard = false
	update_faces()

func get_real_pos(pos):
	return (pos - get_viewport().get_visible_rect().size/2) / camera.zoom

func get_board_pos(pos):
	return (get_real_pos(pos) - board.position) / board.tilesz

func _input(event):
	if event is InputEventMouseButton:
		pass

func score():
	var points = 0
	for i in challange:
		if i["type"] == 0:
			points += board.border_between(i["cola"], i["colb"])
		if i["type"] == 1:
			points -= board.border_between(i["cola"], i["colb"]) * 4
	return points
			

func _button_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:	
		if event.button_index == 1:
			if event.pressed && can_serve: 
				print("You got ", score(), " points")
				generate_challange()
				print_challange()
				board.reset_tiles()
				update_faces()
				buttonclick.z_index = 2
				for i in ingredients:
					i.reset()
			else:
				buttonclick.z_index = 0
					


func _on_timer_timeout() -> void:
	print("dead")
