extends Node2D

@export  var type   = 0
@onready var sprite = $Sprite2D

func _ready() -> void:
	if type < len(Globals.ingredient_texs):
		sprite.texture = Globals.ingredient_texs[type]


func _process(delta: float) -> void:
	pass
