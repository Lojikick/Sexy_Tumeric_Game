extends Node2D

signal player_entering(direction, axis)

@export var axis_allowed: int = -1
@export var direction_allowed: String = "right"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#func _on_area_entered(body: Node2D) -> void:
	##pass # Replace with function body.
	#print("Diddy")
	#if body.is_in_group("Player"):
		#print("Finna dzzz")
		#player_entering.emit("right",-1)


func _on_area_2d_area_entered(body: Area2D) -> void:
	#print("Diddy")
	if body.is_in_group("Player"):
		#var direction_entered = get_entry_direction(body)
		#print("Player came from this direction", direction_entered)
		player_entering.emit(direction_allowed,axis_allowed)

func get_entry_direction(player_body: Area2D) -> String:
	# Get the center positions
	var area_center = global_position
	var player_center = player_body.global_position
	
	# Calculate the difference
	var diff = player_center - area_center
	
	# Determine which axis has the greater difference
	if abs(diff.x) > abs(diff.y):
		# Horizontal entry
		if diff.x > 0:
			return "right"  # Player is to the right, so entered from right
		else:
			return "left"   # Player is to the left, so entered from left
	else:
		# Vertical entry
		if diff.y > 0:
			return "bottom" # Player is below, so entered from bottom
		else:
			return "top"    # Player is above, so entered from top
