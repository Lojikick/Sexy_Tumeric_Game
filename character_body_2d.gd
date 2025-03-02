extends CharacterBody2D


@onready var air_dash_timer: Timer = $AirDashTimer
@onready var floor_dash_timer: Timer = $FloorDashTimer
@onready var air_dash_cooldown: Timer = $AirDashCooldown
@onready var floor_dash_cooldown: Timer = $FloorDashCooldown
@onready var gravity_pause: Timer = $GravityPause
@onready var air_jump_timer: Timer = $AirJumpTimer

#@onready var motion_pause: Timer = $MotionPause
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D




const SPEED = 400.0
const JUMP_VELOCITY = -500.0
const WALL_JUMP_VELOCITY = 700.0
const AIR_DASH_SPEED = 1000.0
const FLOOR_DASH_SPEED = 800.0
var is_air_dashing = false
var air_dash_count = 0
var is_floor_dashing = false
var is_air_cooldown = false
var is_floor_cooldown = false
var is_gravity_paused = false
var is_motion_paused = false
var is_on_air_wall = false
var is_wall_jumping = false
var air_wall_count = 0
var is_facing_right = true





func _physics_process(delta: float) -> void:
	
	
	
	
	
	
	#starts air dash cooldown once on the floor
	if is_on_floor() and air_dash_count > 0:
		is_air_cooldown = true
		air_dash_cooldown.start()
		
	#resets air dash and air wall count once on the floor
	if is_on_floor():
			air_dash_count = 0
			air_wall_count = 0
	
	if Input.is_action_just_pressed("dash") and air_dash_count < 2:
		
		
		#triggers an air dash
		if not is_on_floor() and not is_air_cooldown:
			is_air_dashing = true
			air_dash_timer.start()
			if Input.is_action_pressed("up"):
				velocity = Vector2(0, AIR_DASH_SPEED * -1)
				if is_facing_right:
					animated_sprite_2d.rotation_degrees = -90
				elif not is_facing_right:
					animated_sprite_2d.rotation_degrees = 90
				
			elif Input.is_action_pressed("down"):
				velocity = Vector2(0, AIR_DASH_SPEED)
				if is_facing_right:
					animated_sprite_2d.rotation_degrees = 90
				elif not is_facing_right:
					animated_sprite_2d.rotation_degrees = -90
				
			elif is_facing_right:
				velocity.x = AIR_DASH_SPEED * 1
				velocity.y = 0
			elif not is_facing_right:
				velocity.x = AIR_DASH_SPEED * -1
				velocity.y = 0
			
			air_dash_count += 1
			is_on_air_wall = false
			
		#triggers a floor dash
		elif is_on_floor() and not is_floor_cooldown:
			is_floor_dashing = true
			floor_dash_timer.start()
			is_floor_cooldown = true
			floor_dash_cooldown.start()
			
			if Input.is_action_pressed("up") and not is_air_cooldown:
				velocity = Vector2(0, AIR_DASH_SPEED * -1)
				if is_facing_right:
					animated_sprite_2d.rotation_degrees = -90
				elif not is_facing_right:
					animated_sprite_2d.rotation_degrees = 90
				air_dash_count += 1
			
			elif is_facing_right:
				velocity.x = FLOOR_DASH_SPEED * 1
				
			elif not is_facing_right:
				velocity.x = FLOOR_DASH_SPEED * -1
			
			
			
	



	# Add the gravity.
	if not is_on_floor() and not is_air_dashing and not is_gravity_paused:
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_air_dashing:
		velocity.y = JUMP_VELOCITY
		
		
	#sticks the character in place in the air
	if Input.is_action_just_pressed("spawn wall") and not is_on_floor() and not is_air_dashing and air_wall_count < 2:
		is_on_air_wall = true
		if is_facing_right:
			is_facing_right = false
		elif not is_facing_right:
			is_facing_right = true
		
	if is_on_air_wall:
		velocity = Vector2(0, 0)
		
		
	if Input.is_action_just_released("spawn wall") and not is_air_dashing:
		air_wall_count += 1
		is_on_air_wall = false
		
		
	if is_on_air_wall and Input.is_action_just_pressed("jump"):
		
		air_jump_timer.start()
		is_wall_jumping = true
		
		Input.is_action_just_released("spawn wall")
		is_on_air_wall = false
		
		if not is_facing_right:
			velocity.x = WALL_JUMP_VELOCITY * -1
			velocity.y = JUMP_VELOCITY
			#is_facing_right = false
			
		elif is_facing_right:
			velocity.x = WALL_JUMP_VELOCITY
			velocity.y = JUMP_VELOCITY
			#is_facing_right = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move left", "move right")
	if not is_air_dashing and not is_floor_dashing and not is_motion_paused and not is_on_air_wall and not is_wall_jumping:
		
		if direction > 0:
			is_facing_right = true
			
			
		elif direction < 0:
			is_facing_right = false
			
		
		
		if direction:
			velocity.x = direction * SPEED
			
		elif not is_on_floor():
			var des_rate = SPEED * 0.03
			velocity.x = move_toward(velocity.x, 0, des_rate)
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			
			
			
	#controls sprite animations
	if is_floor_dashing or is_air_dashing:
		animated_sprite_2d.play("dash")
		
	elif is_on_air_wall:
		animated_sprite_2d.play("wallcling")
		
	elif is_wall_jumping:
		animated_sprite_2d.play("walljump")
		
		
	else:
		animated_sprite_2d.play("default")
		animated_sprite_2d.rotation_degrees = 0
	
	#flips the sprite
	if is_facing_right:
		animated_sprite_2d.flip_h = false
	elif not is_facing_right:
		animated_sprite_2d.flip_h = true
	
		
	
		
		
	move_and_slide()

	#is_on_air_wall = false

#actions for when the air dash ends
#pauses gravity and motion briefly
#adds some vertical and horizontal momentum to make it feel more smooth
func _on_air_dash_timer_timeout() -> void:
	gravity_pause.start()
	is_gravity_paused = true
	#motion_pause.start()
	#is_motion_paused = true
	is_air_dashing = false
	var des_rate = AIR_DASH_SPEED * 0.5
	velocity.x = move_toward(velocity.x, 0, des_rate)
	velocity.y = move_toward(velocity.y, 0, des_rate)

#actions for when the floor dash ends
func _on_floor_dash_timer_timeout() -> void:
	is_floor_dashing = false
	


func _on_air_dash_cooldown_timeout() -> void:
	is_air_cooldown = false


func _on_floor_dash_cooldown_timeout() -> void:
	is_floor_cooldown = false


func _on_gravity_pause_timeout() -> void:
	is_gravity_paused = false


#func _on_motion_pause_timeout() -> void:
	#is_motion_paused = false


func _on_air_jump_timer_timeout() -> void:
	is_wall_jumping = false
