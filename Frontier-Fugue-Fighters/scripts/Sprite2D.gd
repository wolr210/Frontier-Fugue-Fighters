extends Sprite2D

var startFrameCount = 0
var player1InputFrame = 0
var player1Input = false

var miss_sound = null
var metronome = null

# Called when the node enters the scene tree for the first time.
func _ready():
	startFrameCount = Engine.get_frames_drawn()
	miss_sound = get_node("miss_sound")
	metronome = get_node("metronome")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
