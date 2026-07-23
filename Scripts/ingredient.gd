extends Node2D

@export  var type   = 0
@onready var sprite = $Sprite2D

var mouse_on        = false
var grabbed         = false
var onboard         = false
var origin          

func _ready() -> void:
	origin = position
	if type >= len(Globals.ingredient_texs):
		print("indexing outside of ingredient_texs list, type:", type, "len(Globals.ingredient_texs):", len(Globals.ingredient_texs))


func _process(delta: float) -> void:
	if grabbed:
		sprite.texture = Globals.ingredient_texs[type]
	else:
		sprite.texture = Globals.ingredient_back_texs[type]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if mouse_on:
					grabbed = true
			else:
				grabbed = false
				get_parent().drop(self)
				

func _on_mouse_entered() -> void:
	mouse_on = true

func _on_mouse_exited() -> void:
	mouse_on = false
