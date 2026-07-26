extends Node2D

@onready var roundtext = $Roundtext
@onready var buttonpressed = $Buttonpressed
@onready var pressedmenu   = $Pressedmenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roundtext.text = "round " + str(Globals.rounds_done)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				buttonpressed.z_index = 1
			else:
				buttonpressed.z_index = -1
				get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if not event.pressed:
				buttonpressed.z_index = -1
				pressedmenu.z_index = -1

func _on_menu_down() -> void:
	pressedmenu.z_index = 1

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
