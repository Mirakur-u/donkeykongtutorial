extends CharacterBody2D

class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var climb_speed = 250.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


var current_direction = 1
var snap_to_ladder_position_x = null
var can_climb = false
var is_on_ladder = false 
var platform_underneath_player = null


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() && !is_on_ladder:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction && !is_on_ladder:
		velocity.x = direction * SPEED
		if direction != current_direction:
			current_direction = direction
		if direction >= 0: 
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.x != 0:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")

	move_and_slide()


	var collision = handle_movement_collision()
	handle_ladder_climbing(collision, delta)
	
	
	if is_on_ladder && is_on_floor():
		is_on_ladder = false
		animated_sprite_2d.play("idle")


func handle_movement_collision():
	var collision = get_last_slide_collision() as KinematicCollision2D
	if !collision:
		return
		
	var collider = collision.get_collider()
	
	if collider is Platform:
		var collision_degrees = roundf(rad_to_deg(collision.get_angle()))
		if collision_degrees == 90:
			position.y -= 8
	
	return collision


func start_climbing(ladder_position_x):
	snap_to_ladder_position_x = ladder_position_x
	can_climb = true
	


func stop_climbing():
	snap_to_ladder_position_x = null
	can_climb = false
	is_on_ladder = false

func handle_ladder_climbing(collision, delta):
	if !can_climb:
		return
	
	var climb_direction = Input.get_axis("down","up")
	
	if climb_direction != 0:
		is_on_ladder = true
		animated_sprite_2d.play("climb")
		position.x = snap_to_ladder_position_x
		
	if climb_direction == -1 && collision && collision.get_collider() is Platform:
		var platform = collision.get_collider() as Platform
		if platform.can_be_disabled:
			platform_underneath_player = platform
			platform_underneath_player.disable_collision()
		
	
	if climb_direction == 1 && platform_underneath_player:
		platform_underneath_player.enable_collision()
		platform_underneath_player = null
			
	if is_on_floor() && velocity.x != 0 && platform_underneath_player:
		platform_underneath_player.enable_collision()
		platform_underneath_player = null
		
	position.y -= climb_direction * climb_speed * delta
