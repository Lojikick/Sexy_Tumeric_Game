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
	
#@onready var timer = $Timer
@export var player: CharacterBody2D
@export var camera: Camera2D

enum States {ALIVE, DEAD}

#Inits player state as alive
var state: States = States.ALIVE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Connect the Game State to the playerDied signal emitted from a Character2D instance
	#Should be just the player instance itself, will update later
	#Calls setDeathState()
	var level_gates = get_tree().get_nodes_in_group("level_gate")
	player.connect("playerDied", setDeathState)
	
	for gate in level_gates:
		if gate.has_signal("player_entering"):
			gate.connect("player_entering", _on_level_gate_player_entering)

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

func enter_level(direction, axis) -> void:
	print("Finna player entering!")
	camera.update_position(direction, axis)

func _on_level_gate_player_entering(direction, axis) -> void:
	print("Finna player entering!")
	camera.update_position(direction, axis)
	
