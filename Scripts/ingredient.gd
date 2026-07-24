extends Node2D

@export  var type       = 0
@onready var sprite     = $Sprite2D
@onready var area       = $Area2D
@onready var pickupsfx  = $pickupsfx
@onready var putdownsfx = $putdownsfx

var grabbed         = false
var onboard         = false
var grab_vec        = Vector2(0,0)
var rot             = 0
var origin          

func _ready() -> void:
	origin = position
	print(type)
	if type >= len(Globals.ingredient_texs):
		print("indexing outside of ingredient_texs list, type: ", type, "  len(Globals.ingredient_texs):", len(Globals.ingredient_texs))
	else:
		sprite.texture = Globals.ingredient_back_texs[type]

	var m = centroid()
	for i in Globals.ingredient_structure[type]:
		var shape = CollisionShape2D.new()
		var rect  = RectangleShape2D.new()
		rect.size = Vector2(16,16)
		shape.shape = rect
		shape.position = 16*(Vector2(i[0], i[1]) - m)
		area.add_child(shape)

func _collision_inp(viewport, event, shape):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed:
			grab_vec = position - get_parent().get_real_pos(event.position)
			z_index  = 4
			grabbed  = true
			pickupsfx.play()
			if onboard: get_parent().grab(self)

func centroid():
	var points = []
	for i in Globals.ingredient_structure[type]:
		for k in range(rot):
			i = [-i[1], i[0]]
		points.append(i)
	return Globals.midpoint(points)
	
func reset():
	position = origin
	onboard = false
	rot = 0
	rotation = 0
	
func _process(delta: float) -> void:
	if grabbed || onboard:
		sprite.texture = Globals.ingredient_texs[type]
	else:
		sprite.texture = Globals.ingredient_back_texs[type]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.pressed:
				if grabbed:
					get_parent().drop(self)
				grabbed = false
				z_index = 0
				

	if event is InputEventKey:
		if grabbed:
			if event.keycode == KEY_R && event.pressed && not event.echo:
				rot += 1
				rot = rot % 4
				rotation += PI/2
