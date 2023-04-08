extends Node2D
var fight_scene = load("res://fight.tscn")

func _ready():
	DisplayServer.window_set_size(Vector2(1920, 1080))
	DisplayServer.window_set_position(Vector2(0,0))
	Engine.set_max_fps(60)
	
func _process(_delta):
	pass
	
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_key_pressed(KEY_1):
		print("trying to change")
		get_tree().change_scene_to_file("res://fight.tscn")
		print("changed")
