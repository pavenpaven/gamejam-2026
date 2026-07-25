extends Node2D

@onready var sprite  = $AnimatedSprite2D
@onready var mes1    = $Message1
@onready var mes2    = $Message2
@onready var mes3    = $Message3
@onready var mes4    = $Message4
@onready var mes5    = $Message5
@onready var face    = $Face
@onready var text    = $Text
@onready var textbox = $Textbox


var character_id 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.animation = "normal_" + str(character_id)
	sprite.play()

func set_textbox(request):
	if request["type"] == 0:
		mes1.texture = Globals.color_symbol_texs[request["cola"]]
		mes2.texture = Globals.color_symbol_texs[request["colb"]]
		mes3.texture = Globals.slash_tex
		mes4.texture = Globals.num_texs[request["num"]]
		mes5.texture = Globals.num_texs[0]

		mes5.position += Vector2(3,4)
		mes3.position += Vector2(10,0)
		mes4.position += Vector2(2,3)

		var offset = Vector2(-2,0)
		mes1.position += offset
		mes2.position += offset
		mes3.position += offset
		mes4.position += offset
		mes5.position += offset
		
	if request["type"] == 1:
		mes1.texture = Globals.color_symbol_texs[request["cola"]]
		mes2.texture = Globals.separate_symbol_tex
		mes3.texture = Globals.color_symbol_texs[request["colb"]]
		mes4.z_index = -1
		mes5.z_index = -1
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
