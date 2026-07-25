extends Node2D

@onready var roundtext = $Roundtext

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roundtext.text = "round " + str(Globals.rounds_done)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				get_tree().change_scene_to_file("res://Scenes/game.tscn")
