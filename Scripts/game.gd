extends Node2D

@onready var camera      = $Camera2D
@onready var board       = $Board
@onready var buttonclick = $Buttonclicked
@onready var button      = $Sprite2D
@onready var timertext   = $Timertext
@onready var timer       = $Timer
@onready var mess        = $Mess
@onready var label       = $Label
@onready var ingredients = [
	$Ingredient, $Ingredient2, $Ingredient3
	, $Ingredient4, $Ingredient5, $Ingredient6
	, $Ingredient7, $Ingredient8]


var markers = []

var can_serve = false
var characters = []
var challange

var timer_length = 60
var round_num    = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.casual_mode:
		timer_length = 300

	Globals.rounds_done = 0
	for i in range(5):
		var sp = Sprite2D.new()
		sp.texture = Globals.dark_trans_tex
		sp.position = Vector2(1000,1000)
		markers.append(sp)
		add_child(sp)
		
	
	generate_challange()
	print_challange()
	update_faces()

func satisfied(req):
	if req["type"] == 0:
		return board.border_between(req["cola"], req["colb"]) >= req["num"]
	if req["type"] == 1:
		return board.border_between(req["cola"], req["colb"]) == 0
	return false
	
	
func update_can_serve():
	var all_ingredients_onboard = true
	for i in ingredients:
		if not i.onboard:
			all_ingredients_onboard = false

	var all_reqs_satisfied = true

	for req in challange:
		if not satisfied(req):
			all_reqs_satisfied = false
	if not all_reqs_satisfied:
		mess.text = "Not all requests \nsatisfied"
		mess.z_index = 0
		can_serve = false
		return
	if not all_ingredients_onboard:
		mess.text = "Not all \ningredients used"
		mess.z_index = 0
		can_serve = false
		return
	can_serve = true
	mess.z_index = -1

func difficulty(cha):
	var diff = 0

	for req in cha:
		if req["type"] == 0: # neighbouring
			if req["cola"] == 4 || req["colb"] == 4:
				diff += 3
			else:
				diff += 4
		if req["type"] == 1: # not neighbouring
			if req["cola"] == 4 || req["colb"] == 4:
				diff += 20
			else:
				diff += 8
	return diff
			
			
			
	
	
func random_request():
	var type = randi() % 2
	if type == 1:
		type = randi() % 2

	if type == 0:
		var cola
		var colb
		if round_num > 1:
			cola = randi() % 5
			colb = randi() % 4
		else:
			cola = randi() % 4
			colb = randi() % 3
		if colb >= cola: # this is to enshure that they are distinct
			colb += 1
		return {"type":0, "cola": cola, "colb": colb, "num": 3}
	if type == 1:
		var cola
		var colb
		if round_num > 5:
			cola = randi() % 5
			colb = randi() % 4
		else:
			cola = randi() % 4
			colb = randi() % 3
		if colb >= cola:
			colb += 1
		return {"type":1, "cola": cola, "colb": colb}
	

func incompatible(req1, req2):
	if req1["type"] == 0 || req1["type"] == 1:
		return ((req1["cola"] == req2["cola"] && req1["colb"] == req2["colb"])
			||  (req1["cola"] == req2["colb"] && req1["colb"] == req2["cola"]))
	print("warning missing incompatiblility check")
	return true

func illegal_chal(chal):
	var num_eq_neg = 0
	for i in chal:
		if i["type"] == 1:
			if i["cola"] == 4 || i["colb"] == 4:
				num_eq_neg += 2
			else:
				num_eq_neg += 1
	if num_eq_neg > 4:
		return true
	return false


func lower_diff():
	return 20 - 20*exp(-round_num / 5)

func upper_diff():
	if round_num >= 6:
		return 24 + 8*round_num
	return [8, 15, 16, 20, 20, 24][round_num]
	
func generate_challange():
	if round_num >= 1:
		label.z_index = -1
	if round_num == 0:
		timer.start(120)
	elif Globals.casual_mode:
		timer.start(120)
	else:
		timer.start(timer_length)
	timer_length = timer_length - timer_length * 0.05

	challange = []
	for i in characters:
		remove_child(i)
		i.queue_free()
	characters = []
	var character_scene = preload("res://Scenes/character.tscn")

	var chal = []
	var diff = -1

	while not (diff > lower_diff() && diff <= upper_diff()):
		chal = gen_chal()
		diff = difficulty(chal)
		if illegal_chal(chal): # skip illegal challanges
			diff = -1

	challange = chal
	

	var count = 0
	while count < len(challange):
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

	Globals.rounds_done = round_num + 1
	round_num += 1
	
	
func gen_chal():
	var chal = []
	var NUM_REQS
	if round_num >= 4:
		NUM_REQS = 4
	else:
		NUM_REQS = [2, 3, 3, 3][round_num]
	
	
	var count = 0
	while count < NUM_REQS: # theres an infite loop here if you set the count bound to high
		var req = random_request()
		var allowed = true
		for j in chal:
			if incompatible(req, j):
				allowed = false
				
		if allowed:
			chal.append(req)
			count += 1
	return chal
	
	
func col_string(col):
	return ["blue", "red", "green", "brown", "empty"][col]

func print_challange():
	for i in challange:
		if i["type"] == 0:
			print("Color ", col_string(i["cola"]) , " next to ", col_string(i["colb"]))
		if i["type"] == 1:
			print("Color ", col_string(i["cola"]) , " not next to ", col_string(i["colb"]))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_left = int(round(timer.time_left))
	
	timertext.text = str(time_left) + "s"

	if can_serve:
		button.z_index = 0
	else:
		button.z_index = -1

	for i in markers:
		i.position = Vector2(1000, 1000)
		
	for ingredient in ingredients:
		if ingredient.grabbed:
			ingredient.position = get_real_pos(get_viewport().get_mouse_position()) + ingredient.grab_vec
			baby_placy(ingredient)

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
	timer.paused = can_serve
	for i in range(len(challange)):
		var req = challange[i]
		if req["type"] == 0:
			var between = board.border_between(req["cola"], req["colb"])
			between = min(req["num"], between)
			var chara  = characters[i]
			if between >= req["num"]:
				chara.sprite.animation = "happy_" + str(chara.character_id)
				chara.face.z_index = 1
				chara.textbox.texture  = Globals.green_text_box_tex
			else:
				chara.sprite.animation = "normal_" + str(chara.character_id)
				chara.face.z_index = -1
				chara.textbox.texture  = Globals.text_box_tex
			chara.mes5.texture = Globals.num_texs[between]
		if req["type"] == 1:
			if satisfied(req):
				var chara = characters[i]
				chara.sprite.animation = "happy_" + str(chara.character_id)
				chara.face.z_index = 1
				chara.textbox.texture  = Globals.green_text_box_tex
			else:
				var chara = characters[i]
				chara.sprite.animation = "angry_" + str(chara.character_id)
				chara.face.z_index = -1
				chara.textbox.texture  = Globals.green_text_box_tex

func baby_placy(ingredient):
	var pos = (ingredient.position - board.position) / board.tilesz
	if pos.x > 0 && pos.x < board.width && pos.y > 0 && pos.y < board.width:
		var center = ingredient.centroid() 

#"		var new_center = Globals.midpoint(points)
		var points = get_tile_pos(ingredient, round(pos - center - Vector2(0.5,0.5)))
		for i in len(points):
			var pnt = points[i]
			markers[i].position = pnt * 16 + board.position + Vector2(8,8)

		var bad = false
		for i in points:
			if not (i.x >= 0 && i.y >= 0 && i.x < 6 && i.y < 6):
				bad = true
		if bad:
			for i in markers:
				i.position = Vector2(1000,1000)
			
				
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
		if event.button_index == 1:
			if not event.pressed:
				buttonclick.z_index = -1

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
			if can_serve:
				if event.pressed: 
					buttonclick.z_index = 2
				else:
					generate_challange()
					print_challange()
					board.reset_tiles()
					update_faces()
					for i in ingredients:
						i.reset()
					buttonclick.z_index = -1


					


func _on_timer_timeout() -> void:
	print("change")
	get_tree().change_scene_to_file("res://Scenes/gameover.tscn")
