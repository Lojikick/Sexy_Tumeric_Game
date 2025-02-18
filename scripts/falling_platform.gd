extends Node2D

@export var fall_speed: float = 15.0 # determines fall speed of rock

@onready var static_body =$StaticBody2D
@onready var trigger_area = $TriggerArea
@onready var fall_timer = $FallTimer
@onready var  self_destruct_timer = $SelfDestructTimer

var is_falling: bool = false


func _process(delta: float) -> void:
	if is_falling:
		global_position.y += fall_speed + delta


func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player Landed")
		trigger_area.monitoring = false
		fall_timer.start()


func _on_fall_timer_timeout() -> void:
	print("Platform Falling")
	is_falling = true
	
	if static_body !=null:
		static_body.collision_layer=0
		static_body.collision_mask=0
	
	self_destruct_timer.start()


func _on_self_destruct_timer_timeout() -> void:
	queue_free()
