extends Area2D

signal goal_scored(side: String)

@export var side: String = "left"  # "left" or "right"

func _on_body_entered(body):
	if body.is_in_group("Ball"):
		print("hello")
		goal_scored.emit(side)
	print("hey")
