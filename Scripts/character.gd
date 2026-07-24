extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var mes1   = $Message1
@onready var mes2   = $Message2
@onready var mes3   = $Message3


var character_id 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "normal_" + str(character_id)
	sprite.play()

func set_textbox(request):
	if request["type"] == 0:
		mes1.texture = Globals.color_symbol_texs[request["cola"]]
		mes1.position += Vector2(9,0)
		mes2.position = Vector2(10000, 10000)
		mes3.texture = Globals.color_symbol_texs[request["colb"]]
		mes3.position -= Vector2(9,0)
	if request["type"] == 1:
		mes1.texture = Globals.color_symbol_texs[request["cola"]]
		mes2.texture = Globals.separate_symbol_tex
		mes3.texture = Globals.color_symbol_texs[request["colb"]]
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
