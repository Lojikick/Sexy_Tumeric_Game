extends Node

## GAME STATE SCRIPT ##
# Manages the major states of the game #
# Player States - Alive, Dead
#USE:
#Attach this object to the main level node
#For a Player Object add the following:
	#signal playerDied
	#if health == 0:
	#	emit_signal("playerDied")
	
@onready var timer = $Timer

enum States {ALIVE, DEAD}

#Inits player state as alive
var state: States = States.ALIVE
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect the Game State to the playerDied signal emitted from a Character2D instance
	#Should be just the player instance itself, will update later
	#Calls setDeathState()
	$CharacterBody2D.connect("playerDied", setDeathState)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state == States.ALIVE:
		#print("You are alive, get cooking")
		pass
	if state == States.DEAD:
		print("You Died Lmao!")
		
#Inits player state as dead'
#Reloads the current scene
func setDeathState() -> void:
	state = States.DEAD
	get_tree().reload_current_scene()
