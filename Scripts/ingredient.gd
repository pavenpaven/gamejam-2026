extends Node2D

@export  var type   = 0
@onready var sprite = $Sprite2D
@onready var area   = $Area2D

var grabbed         = false
var onboard         = false
var grab_vec        = Vector2(0,0)
var origin          

func _ready() -> void:
	origin = position
	print(type)
	if type >= len(Globals.ingredient_texs):
		print("indexing outside of ingredient_texs list, type:", type, "len(Globals.ingredient_texs):", len(Globals.ingredient_texs))
	else:
		sprite.texture = Globals.ingredient_back_texs[type]

	var m = Globals.midpoint(Globals.ingredient_structure[type])
	for i in Globals.ingredient_structure[type]:
		var shape = CollisionShape2D.new()
		var rect  = RectangleShape2D.new()
		rect.size = Vector2(20,20)
		shape.shape = rect
		shape.position = position + Vector2(i[0], i[1]) - m
		area.add_child(shape)

func _collision_inp(viewport, event, shape):
	print(event)
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed:
			grabbed = true

func _process(delta: float) -> void:
	if grabbed:
		sprite.texture = Globals.ingredient_texs[type]
	else:
		sprite.texture = Globals.ingredient_back_texs[type]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.pressed:
				grabbed = false
				get_parent().drop(self)
