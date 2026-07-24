extends Node2D

@onready var sprite = $AnimatedSprite2D

var character_id 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "normal_" + str(character_id)
	sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
