extends Node2D

var startFrameCount = 0

var player1Model = null
var player1Effects = null
var player1InputFrame = 0
var player1Move = GlobalVars.MOVE_TYPE_NONE
var player1MoveScale = GlobalVars.MOVE_SCALE_PERFECT

var player2Model = null
var player2Effects = null
var player2InputFrame = 0
var player2Move = GlobalVars.MOVE_TYPE_NONE
var player2MoveScale = GlobalVars.MOVE_SCALE_PERFECT

var miss_sound = null
var metronome = null
var randForSound
var black_fade = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randForSound = RandomNumberGenerator.new().randi_range(1,3)
	startFrameCount = Engine.get_frames_drawn()
	metronome = get_node("Sounds/metronome")
	if randForSound == 1:
		miss_sound = get_node("Sounds/miss_sound1")
	elif randForSound == 2:
		miss_sound = get_node("Sounds/miss_sound2")
	else: miss_sound = get_node("Sounds/miss_sound3")
	
	black_fade = get_node("FadeTransition/BlackAnimation")
	black_fade.play('Black_Out')
	
	player1Model = get_node("Player1/Player1Model")
	player1Effects = get_node("Player1/Player1Effects")
	player2Model = get_node("Player2/Player2Model")
	player2Effects = get_node("Player2/Player2Effects")
	
	# load correct player 1 models
	match GlobalVars.PLAYER_1_CHARACTER_SELECT:
		GlobalVars.CHARACTER_RED:
			player1Model.get_node("Player1Idle").animation = "PlayerRed"
			player1Model.get_node("Player1Attack").texture = load("res://graphics/characters/fight sprites/red attack.png")
			player1Model.get_node("Player1Block").texture = load("res://graphics/characters/fight sprites/red defense.png")
			player1Model.get_node("Player1Grab").texture = load("res://graphics/characters/fight sprites/red grab.png")
		GlobalVars.CHARACTER_GREEN:
			player1Model.get_node("Player1Idle").animation = "PlayerGreen"
			player1Model.get_node("Player1Attack").texture = load("res://graphics/characters/fight sprites/green attack.png")
			player1Model.get_node("Player1Block").texture = load("res://graphics/characters/fight sprites/green defense.png")
			player1Model.get_node("Player1Grab").texture = load("res://graphics/characters/fight sprites/green grab.png")
		GlobalVars.CHARACTER_BLUE:
			player1Model.get_node("Player1Idle").animation = "PlayerBlue"
			player1Model.get_node("Player1Attack").texture = load("res://graphics/characters/fight sprites/blue attack.png")
			player1Model.get_node("Player1Block").texture = load("res://graphics/characters/fight sprites/blue defense.png")
			player1Model.get_node("Player1Grab").texture = load("res://graphics/characters/fight sprites/blue grab.png")
			
	# load correct player 2 models
	match GlobalVars.PLAYER_2_CHARACTER_SELECT:
		GlobalVars.CHARACTER_RED:
			player2Model.get_node("Player2Idle").animation = "PlayerRed"
			player2Model.get_node("Player2Attack").texture = load("res://graphics/characters/fight sprites/red attack.png")
			player2Model.get_node("Player2Block").texture = load("res://graphics/characters/fight sprites/red defense.png")
			player2Model.get_node("Player2Grab").texture = load("res://graphics/characters/fight sprites/red grab.png")
		GlobalVars.CHARACTER_GREEN:
			player2Model.get_node("Player2Idle").animation = "PlayerGreen"
			player2Model.get_node("Player2Attack").texture = load("res://graphics/characters/fight sprites/green attack.png")
			player2Model.get_node("Player2Block").texture = load("res://graphics/characters/fight sprites/green defense.png")
			player2Model.get_node("Player2Grab").texture = load("res://graphics/characters/fight sprites/green grab.png")
		GlobalVars.CHARACTER_BLUE:
			player2Model.get_node("Player2Idle").animation = "PlayerBlue"
			player2Model.get_node("Player2Attack").texture = load("res://graphics/characters/fight sprites/blue attack.png")
			player2Model.get_node("Player2Block").texture = load("res://graphics/characters/fight sprites/blue defense.png")
			player2Model.get_node("Player2Grab").texture = load("res://graphics/characters/fight sprites/blue grab.png")
		
	player1Model.get_node("Player1Idle").visible = true
	player1Model.get_node("Player1Idle").play()
	player2Model.get_node("Player2Idle").visible = true
	player2Model.get_node("Player2Idle").play()
	
	player1Effects.get_node("Player1Attack").play()
	player1Effects.get_node("Player1Block").play()
	player1Effects.get_node("Player1Grab").play()
	player2Effects.get_node("Player2Attack").play()
	player2Effects.get_node("Player2Block").play()
	player2Effects.get_node("Player2Grab").play()
	
	countdown()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GlobalVars.PROCESS_FLAG == true:
		var currentFrameCount = Engine.get_frames_drawn()
		var framesTillNextBeat = (currentFrameCount - startFrameCount) % GlobalVars.FRAMES_PER_BEAT
		
		# clear animations if it's the middle of the beat
		if framesTillNextBeat >= GlobalVars.FRAMES_PER_BEAT - 1 and framesTillNextBeat <= GlobalVars.FRAMES_PER_BEAT + 1:
			player1Model.get_node("Player1Idle").visible = true
			player1Model.get_node("Player1Attack").visible = false
			player1Model.get_node("Player1Block").visible = false
			player1Model.get_node("Player1Grab").visible = false
			player1Effects.get_node("Player1Attack").visible = false
			player1Effects.get_node("Player1Block").visible = false
			player1Effects.get_node("Player1Grab").visible = false
			
			player2Model.get_node("Player2Idle").visible = true
			player2Model.get_node("Player2Attack").visible = false
			player2Model.get_node("Player2Block").visible = false
			player2Model.get_node("Player2Grab").visible = false
			player2Effects.get_node("Player2Attack").visible = false
			player2Effects.get_node("Player2Block").visible = false
			player2Effects.get_node("Player2Grab").visible = false
		
		# next beat (adjusted for hearing accuracy)
		if framesTillNextBeat >= GlobalVars.FRAMES_PER_BEAT - 1:
			metronome.play()
			GlobalVars.PLAYER_1_GRABBED_DURATION -= 1
			GlobalVars.PLAYER_2_GRABBED_DURATION -= 1
			GlobalVars.PLAYER_1_COOLDOWN_DURATION -= 1
			GlobalVars.PLAYER_2_COOLDOWN_DURATION -= 1
			print("Player 1 Health:")
			print(GlobalVars.PLAYER_1_HEALTH)
			print("Player 2 Health:")
			print(GlobalVars.PLAYER_2_HEALTH)
			
		# determine player 1 timing
		if GlobalVars.PLAYER_1_GRABBED_DURATION >= 0 or GlobalVars.PLAYER_1_COOLDOWN_DURATION >= 0:
			player1Move = GlobalVars.MOVE_TYPE_NONE
		elif player1Move != GlobalVars.MOVE_TYPE_NONE:
			var player1AlignedInput = (player1InputFrame - startFrameCount) % GlobalVars.FRAMES_PER_BEAT
			if player1AlignedInput <= GlobalVars.TIMING_PERFECT / 2:
				player1MoveScale = GlobalVars.MOVE_SCALE_PERFECT
			elif player1AlignedInput <= (GlobalVars.TIMING_PERFECT / 2) + GlobalVars.TIMING_LATE_PERFECT:
				player1MoveScale = GlobalVars.MOVE_SCALE_LATE_PERFECT
			elif player1AlignedInput <= GlobalVars.FRAMES_PER_BEAT / 2:
				player1MoveScale = GlobalVars.MOVE_SCALE_LATE
				miss_sound.play()
			elif player1AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - 1:
				player1MoveScale = GlobalVars.MOVE_SCALE_PERFECT
			elif player1AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - GlobalVars.TIMING_EARLY_PERFECT - 1:
				player1MoveScale = GlobalVars.MOVE_SCALE_EARLY_PERFECT
			elif player1AlignedInput >= (GlobalVars.FRAMES_PER_BEAT / 2) + 1:
				player1MoveScale = GlobalVars.MOVE_SCALE_EARLY
				miss_sound.play()
			
		# determine player 2 timing	
		if GlobalVars.PLAYER_2_GRABBED_DURATION >= 0 or GlobalVars.PLAYER_2_COOLDOWN_DURATION >= 0:
			player2Move = GlobalVars.MOVE_TYPE_NONE
		elif player2Move != GlobalVars.MOVE_TYPE_NONE:
			var player2AlignedInput = (player2InputFrame - startFrameCount) % GlobalVars.FRAMES_PER_BEAT
			if player2AlignedInput <= GlobalVars.TIMING_PERFECT / 2:
				player2MoveScale = GlobalVars.MOVE_SCALE_PERFECT
			elif player2AlignedInput <= (GlobalVars.TIMING_PERFECT / 2) + GlobalVars.TIMING_LATE_PERFECT:
				player2MoveScale = GlobalVars.MOVE_SCALE_LATE_PERFECT
			elif player2AlignedInput <= GlobalVars.FRAMES_PER_BEAT / 2:
				player2MoveScale = GlobalVars.MOVE_SCALE_LATE
				miss_sound.play()
			elif player2AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - 1:
				player2MoveScale = GlobalVars.MOVE_SCALE_PERFECT
			elif player2AlignedInput >= GlobalVars.FRAMES_PER_BEAT - (GlobalVars.TIMING_PERFECT / 2) - GlobalVars.TIMING_EARLY_PERFECT - 1:
				player2MoveScale = GlobalVars.MOVE_SCALE_EARLY_PERFECT
			elif player2AlignedInput >= (GlobalVars.FRAMES_PER_BEAT / 2) + 1:
				player2MoveScale = GlobalVars.MOVE_SCALE_EARLY
				miss_sound.play()
		
		# determines combination of player 1 move and player 2 move
		match player1Move:
			GlobalVars.MOVE_TYPE_NONE:
				match player2Move:
					GlobalVars.MOVE_TYPE_NONE: # p1 none, p2 none --> nothing
						pass
					GlobalVars.MOVE_TYPE_ATTACK: # p1 none, p2 atk --> p1 damaged
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = true
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = true
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = false
						GlobalVars.PLAYER_1_HEALTH -= GlobalVars.ATTACK_POWER_MAX * player2MoveScale
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_BLOCK: # p1 none, p2 block --> nothing
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = true
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = true
						player2Effects.get_node("Player2Grab").visible = false
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_GRAB: # p1 none, p2 grab --> p1 grabbed if not already grabbed within last 8 beats
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = true
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = true
						if GlobalVars.PLAYER_1_GRABBED_DURATION < -3:
							GlobalVars.PLAYER_1_GRABBED_DURATION = GlobalVars.GRAB_DURATION_MAX * player2MoveScale
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
						
			GlobalVars.MOVE_TYPE_ATTACK:
				player1Model.get_node("Player1Idle").visible = false
				player1Model.get_node("Player1Attack").visible = true
				player1Model.get_node("Player1Block").visible = false
				player1Model.get_node("Player1Grab").visible = false
				player1Effects.get_node("Player1Attack").visible = true
				player1Effects.get_node("Player1Block").visible = false
				player1Effects.get_node("Player1Grab").visible = false
				match player2Move:
					GlobalVars.MOVE_TYPE_NONE: # p1 attack, p2 none --> p2 damaged
						GlobalVars.PLAYER_2_HEALTH -= GlobalVars.ATTACK_POWER_MAX * player1MoveScale
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_ATTACK: # p1 attack, p2 attack --> nothing (clash)
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = true
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = true
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = false
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_BLOCK: # p1 attack, p2 block --> p2 block damage based on timing
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = true
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = true
						player2Effects.get_node("Player2Grab").visible = false
						var damage_calc = GlobalVars.ATTACK_POWER_MAX * (player1MoveScale - GlobalVars.BLOCK_PERCENT_MAX * player2MoveScale)
						GlobalVars.PLAYER_2_HEALTH -= max(0, damage_calc)
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_GRAB: # p1 attack, p2 grab --> p2 damaged
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = true
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = true
						GlobalVars.PLAYER_2_HEALTH -= GlobalVars.ATTACK_POWER_MAX * player1MoveScale
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 2
						
			GlobalVars.MOVE_TYPE_BLOCK:
				player1Model.get_node("Player1Idle").visible = false
				player1Model.get_node("Player1Attack").visible = false
				player1Model.get_node("Player1Block").visible = true
				player1Model.get_node("Player1Grab").visible = false
				player1Effects.get_node("Player1Attack").visible = false
				player1Effects.get_node("Player1Block").visible = true
				player1Effects.get_node("Player1Grab").visible = false
				match player2Move:
					GlobalVars.MOVE_TYPE_NONE: # p1 block, p2 none --> nothing
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_ATTACK: # p1 block, p2 attack --> p1 block damage based on timing
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = true
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = true
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = false
						var damage_calc = GlobalVars.ATTACK_POWER_MAX * (player2MoveScale - GlobalVars.BLOCK_PERCENT_MAX * player1MoveScale)
						GlobalVars.PLAYER_1_HEALTH -= max(0, damage_calc)
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_BLOCK: # p1 block, p2 block --> nothing
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = true
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = true
						player2Effects.get_node("Player2Grab").visible = false
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_GRAB: # p1 block, p2 grab --> p1 grabbed if not already grabbed within last 8 beats
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = true
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = true
						if GlobalVars.PLAYER_1_GRABBED_DURATION < -3:
							GlobalVars.PLAYER_1_GRABBED_DURATION = GlobalVars.GRAB_DURATION_MAX * player2MoveScale
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
						
			GlobalVars.MOVE_TYPE_GRAB:
				player1Model.get_node("Player1Idle").visible = false
				player1Model.get_node("Player1Attack").visible = false
				player1Model.get_node("Player1Block").visible = false
				player1Model.get_node("Player1Grab").visible = true
				player1Effects.get_node("Player1Attack").visible = false
				player1Effects.get_node("Player1Block").visible = false
				player1Effects.get_node("Player1Grab").visible = true
				match player2Move:
					GlobalVars.MOVE_TYPE_NONE: # p1 grab, p2 none --> p2 grabbed if not already grabbed within last 8 beats
						if GlobalVars.PLAYER_2_GRABBED_DURATION < -3:
							GlobalVars.PLAYER_2_GRABBED_DURATION = GlobalVars.GRAB_DURATION_MAX * player1MoveScale
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 2
					GlobalVars.MOVE_TYPE_ATTACK: # p1 grab, p2 attack --> p1 damaged
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = true
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = true
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = false
						GlobalVars.PLAYER_1_HEALTH -= GlobalVars.ATTACK_POWER_MAX * player2MoveScale
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 2
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_BLOCK: # p1 grab, p2 block --> p2 grabbed if not already grabbed within last 8 beats
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = true
						player2Model.get_node("Player2Grab").visible = false
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = true
						player2Effects.get_node("Player2Grab").visible = false
						if GlobalVars.PLAYER_2_GRABBED_DURATION < -3:
							GlobalVars.PLAYER_2_GRABBED_DURATION = GlobalVars.GRAB_DURATION_MAX * player1MoveScale
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 1
					GlobalVars.MOVE_TYPE_GRAB: # p1 grab, p2 grab --> nothing (clash)
						player2Model.get_node("Player2Idle").visible = false
						player2Model.get_node("Player2Attack").visible = false
						player2Model.get_node("Player2Block").visible = false
						player2Model.get_node("Player2Grab").visible = true
						player2Effects.get_node("Player2Attack").visible = false
						player2Effects.get_node("Player2Block").visible = false
						player2Effects.get_node("Player2Grab").visible = true
						GlobalVars.PLAYER_1_COOLDOWN_DURATION = 2
						GlobalVars.PLAYER_2_COOLDOWN_DURATION = 2
						
		player1Move = GlobalVars.MOVE_TYPE_NONE
		player2Move = GlobalVars.MOVE_TYPE_NONE
		
		# checks endgame states
		if GlobalVars.PLAYER_1_HEALTH <= 0:
			print("Player 2 wins!")
			get_tree().quit()
		elif GlobalVars.PLAYER_2_HEALTH <= 0:
			print("Player 1 wins!")
			get_tree().quit() 
			
		
	
func _input(_ev):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_action_just_pressed("player1_move_attack"):
		player1InputFrame = Engine.get_frames_drawn()
		player1Move = GlobalVars.MOVE_TYPE_ATTACK
	elif Input.is_action_just_pressed("player1_move_block"):
		player1InputFrame = Engine.get_frames_drawn()
		player1Move = GlobalVars.MOVE_TYPE_BLOCK
	elif Input.is_action_just_pressed("player1_move_grab"):
		player1InputFrame = Engine.get_frames_drawn()
		player1Move = GlobalVars.MOVE_TYPE_GRAB
	elif Input.is_action_just_pressed("player2_move_attack"):
		player2InputFrame = Engine.get_frames_drawn()
		player2Move = GlobalVars.MOVE_TYPE_ATTACK
	elif Input.is_action_just_pressed("player2_move_block"):
		player2InputFrame = Engine.get_frames_drawn()
		player2Move = GlobalVars.MOVE_TYPE_BLOCK
	elif Input.is_action_just_pressed("player2_move_grab"):
		player2InputFrame = Engine.get_frames_drawn()
		player2Move = GlobalVars.MOVE_TYPE_GRAB
	

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
