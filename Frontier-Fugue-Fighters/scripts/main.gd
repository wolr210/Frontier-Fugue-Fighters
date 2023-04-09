extends Node2D
var fight_scene = load("res://fight.tscn")

var grey_pixel_shader = load("res://graphics/shaders/greyscale_pixelate.gdshader")
var pixel_shader = load("res://graphics/shaders/pixelate.gdshader")

var red_character = null
var green_character = null
var blue_character = null

var red_character_max_x = 1920 / 3;
var green_character_max_x = 2 * 1920 / 3;
var blue_character_max_x = 1920;

# ALL audios for the start
var transition_sound = null
var char_ready = null
var Background_Audio;
var black_fade = null

func _ready():
	DisplayServer.window_set_size(Vector2(1920, 1080))
	DisplayServer.window_set_position(Vector2(0,0))
	Engine.set_max_fps(60)
	red_character = get_node("choose_red/choose_red")
	green_character = get_node("choose_green/choose_green")
	blue_character = get_node("choose_blue/choose_blue")
	transition_sound = get_node("Transition_Audio_Sel")
	get_node("top_text/select_char").visible = true
	get_node("top_text/press_enter").visible = false
	
	get_node("selection_tokens/p1_token").visible = false
	get_node("selection_tokens/p2_token").visible = false

	black_fade = get_node("CanvasLayer/BlackAnimation")
	char_ready = get_node("Char_Fully_Selected")
	Background_Audio = get_node("Select_Char_Back_Audio")
	Background_Audio.play()
	
	
	
func _process(_delta):
	var current_mouse_position = get_viewport().get_mouse_position()
	
	#hover over to highlight character
	if current_mouse_position.x < red_character_max_x:
		red_character.material.shader = pixel_shader
		green_character.material.shader = grey_pixel_shader
		blue_character.material.shader = grey_pixel_shader
	elif current_mouse_position.x < green_character_max_x:
		red_character.material.shader = grey_pixel_shader
		green_character.material.shader = pixel_shader
		blue_character.material.shader = grey_pixel_shader
	else:
		red_character.material.shader = grey_pixel_shader
		green_character.material.shader = grey_pixel_shader
		blue_character.material.shader = pixel_shader
		
	if GlobalVars.PLAYER_1_CHARACTER_CHOSEN and GlobalVars.PLAYER_2_CHARACTER_CHOSEN:
		get_node("top_text/select_char").visible = false
		get_node("top_text/press_enter").visible = true
	
func _input(ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_key_pressed(KEY_ENTER) and GlobalVars.PLAYER_1_CHARACTER_CHOSEN and GlobalVars.PLAYER_2_CHARACTER_CHOSEN:
		print("trying to change")
		#print(GlobalVars.PLAYER_1_CHARACTER_CHOSEN and GlobalVars.PLAYER_2_CHARACTER_CHOSEN)
		black_fade.play('Black_In')
		char_ready.play()
		
		for i in range(0,-50,-1):
			Background_Audio.set_volume_db(i)
			await get_tree().create_timer(0.02).timeout
			
		await get_tree().create_timer(1).timeout
		
		get_tree().change_scene_to_file("res://fight.tscn")
		print("changed")
	elif Input.is_action_just_pressed("click"):
		var current_mouse_position = get_viewport().get_mouse_position()
		# character select
		if !GlobalVars.PLAYER_1_CHARACTER_CHOSEN:
			if current_mouse_position.x < red_character_max_x:
				GlobalVars.PLAYER_1_CHARACTER_SELECT = GlobalVars.CHARACTER_RED
			elif current_mouse_position.x < green_character_max_x:
				GlobalVars.PLAYER_1_CHARACTER_SELECT = GlobalVars.CHARACTER_GREEN
				get_node("selection_tokens/p1_token").position.x += 1920/3;
			else:
				GlobalVars.PLAYER_1_CHARACTER_SELECT = GlobalVars.CHARACTER_BLUE
				get_node("selection_tokens/p1_token").position.x += 2*1920/3;
			GlobalVars.PLAYER_1_CHARACTER_CHOSEN = true
			get_node("selection_tokens/p1_token").visible = true
			transition_sound.play()
			print('player 1 chosen')
			
		elif !GlobalVars.PLAYER_2_CHARACTER_CHOSEN:
			if current_mouse_position.x < red_character_max_x:
				GlobalVars.PLAYER_2_CHARACTER_SELECT = GlobalVars.CHARACTER_RED
			elif current_mouse_position.x < green_character_max_x:
				GlobalVars.PLAYER_2_CHARACTER_SELECT = GlobalVars.CHARACTER_GREEN
				get_node("selection_tokens/p2_token").position.x += 1920/3;
			else:
				GlobalVars.PLAYER_2_CHARACTER_SELECT = GlobalVars.CHARACTER_BLUE
				get_node("selection_tokens/p2_token").position.x += 2*1920/3;
			GlobalVars.PLAYER_2_CHARACTER_CHOSEN = true
			get_node("selection_tokens/p2_token").visible = true
			transition_sound.play()
			print('player 2 chosen')
