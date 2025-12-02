extends CharacterBody2D

@export var speed: float = 300.0 

var is_dribbling: = false
var dribbled_ball: RigidBody2D = null
var dribble_offset: = Vector2(20, 0)

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	
func shoot_ball():
	if not is_dribbling or dribbled_ball == null:
		return
	var direction = velocity.normalized()
	dribbled_ball.stop_dribble()
	is_dribbling = false
	var shot_power := 1500.0
	dribbled_ball.velocity = direction * shot_power
	dribbled_ball = null
