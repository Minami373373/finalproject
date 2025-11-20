extends CharacterBody2D

@export var speed: float = 300.0 

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_ball_detector_body_entered(body: Node2D) -> void:
	var is_dribbling: bool = false
	var dribbled_ball: RigidBody2D = null
