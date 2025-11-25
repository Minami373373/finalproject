extends CharacterBody2D
var is_dribbled := false
var player: CharacterBody2D = null  # the player dribbling the ball

func _physics_process(delta):
	if not is_dribbled:
		move_and_slide()

func follow_player(target_pos: Vector2):
	# Override physics while dribbled
	global_position = global_position.lerp(target_pos, 0.3)

func start_dribble(p: Node2D):
	is_dribbled = true
	player = p

func stop_dribble():
	is_dribbled = false
	player = null
	velocity = Vector2.ZERO
