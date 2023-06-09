extends Node

# BPM and other related variables/functions
var BPM = 120
var FRAMES_PER_BEAT = 3600 / BPM

func UPDATE_BPM(new_bpm):
	BPM = new_bpm
	FRAMES_PER_BEAT = 3600 / BPM

# TIMING and other related variables
const TIMING_EARLY_PERFECT = 3 # number of frames that you can input an early perfect
const TIMING_PERFECT = 4 # number of frames that you can input a perfect; in the code, it is divided by two and checked on each side of the beat
const TIMING_LATE_PERFECT = 3 # number of frames that you can input a late perfect

# GLOBAL ATTACK related variables
const MOVE_TYPE_NONE   = 0
const MOVE_TYPE_ATTACK = 1
const MOVE_TYPE_BLOCK  = 2
const MOVE_TYPE_GRAB   = 3

const ATTACK_POWER_MAX  = 20 # attack damage when on beat
const BLOCK_PERCENT_MAX = 1.0 # percent of damage blocked when on beat (0.0 = no block, 1.0 = full block)
const GRAB_DURATION_MAX = 4 # number of beats that the grab is held for

const ATTACK_ENDLAG = 0 # number of beats you can't do any other move after attacking
const BLOCK_ENDLAG = 0 # number of beats you can't do any other move after blocking
const GRAB_ENDLAG = 1 # number of beats you can't do any other move after grabbing

const MOVE_SCALE_EARLY         = 0.0 # when attacker is early, scale move power/percent/duration by this much
const MOVE_SCALE_EARLY_PERFECT = 0.5 # when attacker is early perfect, scale move power/percent/duration by this much
const MOVE_SCALE_PERFECT       = 1 # when attacker is perfect, scale move power/percent/duration by this much
const MOVE_SCALE_LATE_PERFECT  = 0.5 # when attacker is late perfect, scale move power/percent/duration by this much
const MOVE_SCALE_LATE          = 0.0 # when attacker is late, scale move power/percent/duration by this much

# CHARACTER CHOICES (can be changed during runtime!)
const CHARACTER_RED   = 0
const CHARACTER_GREEN = 1
const CHARACTER_BLUE  = 2
var PLAYER_1_CHARACTER_SELECT = -1
var PLAYER_2_CHARACTER_SELECT = -1

# GAMEPLAY FLAGS (can be changed during runtime!)
var PLAYER_1_CHARACTER_CHOSEN = false
var PLAYER_2_CHARACTER_CHOSEN = false
var FIGHTING_STARTED = false
var FIGHTING_ENDED = false
var PROCESS_FLAG = false
var HIDE_INSTRUCTIONS = false

# GAMEPLAY STATS (can be changed during runtime!)
var PLAYER_1_HEALTH = 500
var PLAYER_2_HEALTH = 500
var PLAYER_1_COOLDOWN_DURATION = -1
var PLAYER_2_COOLDOWN_DURATION = -1
var PLAYER_1_GRABBED_DURATION = -1
var PLAYER_2_GRABBED_DURATION = -1
