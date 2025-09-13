extends Camera2D

@export var player: CharacterBody2D
@onready var size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func update_position(direction: String, axis: int) -> void:
	#var current_cell: Vector2i = Vector2i(player.global_position) / size
	#print("Finna current cell:", current_cell)
	#print("Finna current global position:", global_position)
	if direction == "right":
		global_position.x += size.x
	if direction == "left":
		global_position.x -= size.x
	if direction == "up":
		global_position.y -= size.y
	if direction == "down":
		global_position.y += size.y
		
	pass

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	
