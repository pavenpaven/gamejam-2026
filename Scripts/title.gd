extends Node

@onready var sfx          = $sfx
@onready var trans1       = $Transparent        
@onready var trans2       = $Transparent2       
@onready var creditstitle = $creditstitle 
@onready var credits      = $credits
@onready var settingstitle= $Settingstitle
@onready var keybinds     = $Keybinds

@onready var up_start     = $Startsprite
@onready var dw_start     = $Pushedstartsprite
@onready var up_quit      = $Quitsprite
@onready var dw_quit      = $Pushedquit
@onready var up_credits   = $Creditsbuttonsprite
@onready var dw_credits   = $Pushedcredits
@onready var up_gear      = $Gearsprite
@onready var dw_gear      = $Pressedgear

@onready var up_normal    = $Normalsprite
@onready var dw_normal    = $Pressednormal
@onready var up_casual    = $Casualsprite
@onready var dw_casual    = $Pressedcasual

@onready var normal_arrow = $Normalarrow
@onready var casual_arrow = $Casualarrow


var credits_up  = false
var settings_up = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trans1
	trans2
	creditstitle
	credits
	print(trans1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	dw_start.z_index = 0
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_exit_pressed() -> void:
	dw_quit.z_index = 0
	get_tree().quit()

func fix_casual():
	casual_arrow.z_index = -1
	normal_arrow.z_index = -1
	dw_casual.z_index = -1
	dw_normal.z_index = -1
	if Globals.casual_mode:
		casual_arrow.z_index = 0
		dw_casual.z_index = 1
	else:
		normal_arrow.z_index = 0
		dw_normal.z_index = 1

func reset_layout():
	trans1.z_index   = -1
	trans2.z_index   = -1
	keybinds.z_index = 0

	up_normal.z_index = -1
	dw_normal.z_index = -1
	up_casual.z_index = -1	
	dw_casual.z_index = -1
	casual_arrow.z_index = -1
	normal_arrow.z_index = -1
	settingstitle.z_index = -1

	creditstitle.z_index = -1
	credits.z_index      = -1

	


func _on_settings_pressed() -> void:
	reset_layout()
	dw_gear.z_index = 0

	credits_up = false
	settings_up = not settings_up
	if settings_up:
		settingstitle.z_index = 0
		trans1.z_index   = 0
		trans2.z_index   = 0
		keybinds.z_index = -1
		up_normal.z_index = 0
		dw_normal.z_index = 0
		up_casual.z_index = 0
		dw_casual.z_index = 0
		fix_casual()

func _on_credits_pressed() -> void:
	reset_layout()
	dw_credits.z_index = 0

	settings_up = false
	credits_up = not credits_up
	if credits_up:
		trans1.z_index       = 0
		trans2.z_index       = 0
		keybinds.z_index     = -1
		creditstitle.z_index = 0
		credits.z_index      = 0


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 && not event.pressed:
			dw_start.z_index   = 0
			dw_quit.z_index    = 0
			dw_credits.z_index = 0
			dw_gear.z_index    = 0

func _on_start_down() -> void:
	dw_start.z_index = 1
	sfx.play()

func _on_exit_down() -> void:
	dw_quit.z_index = 1
	sfx.play()

func _on_credits_down() -> void:
	dw_credits.z_index = 1
	sfx.play()

func _on_settings_down() -> void:
	dw_gear.z_index = 1
	sfx.play()


func _on_normal_down() -> void:
	if settings_up:
		Globals.casual_mode = false
		fix_casual()
		sfx.play()


func _on_casual_down() -> void:
	if settings_up:
		Globals.casual_mode = true
		fix_casual()
		sfx.play()
