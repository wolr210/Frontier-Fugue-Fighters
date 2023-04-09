extends Sprite2D

var startFrameCount = 0
var player1InputFrame = 0
var player1Input = false
var miss_sound = null
var metronome = null
var randForSound
var black_fade = null


# Called when the node enters the scene tree for the first time.
func _ready():
	randForSound = RandomNumberGenerator.new().randi_range(1,3)
	startFrameCount = Engine.get_frames_drawn()
	metronome = get_node("metronome")
	if randForSound == 1:
		miss_sound = get_node("miss_sound1")
	elif randForSound == 2:
		miss_sound = get_node("miss_sound2")
	else: miss_sound = get_node("miss_sound3")
	
	black_fade = get_node("CanvasLayer/BlackAnimation")
	black_fade.play('Black_Out')
	
	countdown()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalVars.PROCESS_FLAG == true:
		var currentFrameCount = Engine.get_frames_drawn()
		var framesTillNextBeat = (currentFrameCount - startFrameCount) % GlobalVars.FRAMES_PER_BEAT
		if framesTillNextBeat >= GlobalVars.FRAMES_PER_BEAT - 1:
			metronome.play()
		if framesTillNextBeat <= 1 or framesTillNextBeat >= 29:
			position = Vector2(100,100)
		else:
			position = Vector2(600,600)
		if player1Input:
			player1Input = false
			var player1AlignedInput = (player1InputFrame - startFrameCount) % GlobalVars.FRAMES_PER_BEAT
			if player1AlignedInput <= GlobalVars.TIMING_PERFECT / 2:
				print("PERFECT")
			elif player1AlignedInput <= (GlobalVars.TIMING_PERFECT / 2) + GlobalVars.TIMING_LATE_PERFECT:
				print("LATE PERFECT")
			elif player1AlignedInput <= GlobalVars.FRAMES_PER_BEAT / 2:
				print("LATE")
				miss_sound.play()
			elif player1AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - 1:
				print("PERFECT")
			elif player1AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - GlobalVars.TIMING_EARLY_PERFECT - 1:
				print("EARLY PERFECT")
			elif player1AlignedInput >= (GlobalVars.FRAMES_PER_BEAT / 2) + 1:
				print("EARLY")
	
func _input(_ev):
	if Input.is_key_pressed(KEY_K):
		player1InputFrame = Engine.get_frames_drawn()
		player1Input = true
	elif Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_key_pressed(KEY_0):
		get_tree().change_scene_to_file("res://choose.tscn")
		

func countdown():
	var curr_node= get_node("Countdown/Ready")
	get_node("Countdown/three").hide()
	get_node("Countdown/two").hide()
	get_node("Countdown/one").hide()
	get_node("Countdown/go").hide()
	curr_node.hide()
	
	await get_tree().create_timer(1).timeout
	metronome.play()
	curr_node.show()
	await get_tree().create_timer(1).timeout
	metronome.play()
	await get_tree().create_timer(1).timeout
	metronome.play()
	curr_node.hide()
	curr_node = get_node("Countdown/three")
	curr_node.show()
	await get_tree().create_timer(.47).timeout
	metronome.play()
	curr_node.hide()
	curr_node = get_node("Countdown/two")
	curr_node.show()
	await get_tree().create_timer(.47).timeout
	metronome.play()
	curr_node.hide()
	curr_node = get_node("Countdown/one")
	curr_node.show()
	await get_tree().create_timer(.47).timeout
	metronome.play()
	curr_node.hide()
	curr_node = get_node("Countdown/go")
	curr_node.show()
	await get_tree().create_timer(.47).timeout
	curr_node.hide()
	GlobalVars.PROCESS_FLAG = true
