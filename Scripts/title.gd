extends Node

var trans1       
var trans2       
var creditstitle 
var credits      

var credits_up = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trans1       = $Transparent 
	trans2       = $Transparent2
	creditstitle = $creditstitle
	credits      = $credits
	print(trans1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_credits_pressed() -> void:
	print("credits")
	var z_ind
	credits_up = not credits_up
	if credits_up:
		z_ind = 0
	else:
		z_ind = -1
	trans1.z_index       = z_ind
	trans2.z_index       = z_ind
	creditstitle.z_index = z_ind
	credits.z_index      = z_ind
	
	
