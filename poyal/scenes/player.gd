extends CharacterBody2D

const SPEED = 300.0
var has_ball = false
var ball_ref: RigidBody2D 

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()
	
	if has_ball and is_instance_valid(ball_ref):
		ball_ref.global_position = global_position # Ball follows the player
		ball_ref.linear_velocity = Vector2.ZERO # Stop the ball's physics movement

	if Input.is_action_just_pressed("shoot"):
		shoot_ball()

func pickup_ball(ball_body: RigidBody2D):
	if !has_ball:
		has_ball = true
		ball_ref = ball_body
		ball_ref.freeze = true 
		emit_signal("ball_picked_up")

func shoot_ball():
	if has_ball and is_instance_valid(ball_ref):
		has_ball = false
		ball_ref.freeze = false 
	
		var shoot_direction = velocity.normalized()
		const SHOOT_FORCE = 15000.0
		ball_ref.apply_central_impulse(shoot_direction * SHOOT_FORCE)
		
		ball_ref = null 
		emit_signal("ball_shot")
