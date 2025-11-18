extends CharacterBody2D

@export var speed = 600

# func _physics_process(delta):
	#var velocity = Vector2.ZERO
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "up","ui_down")
	velocity = input_direction * speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
