extends Node2D

@export  var type   = 0
@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = Globals.ingredient_texs[type]


func _process(delta: float) -> void:
	pass
