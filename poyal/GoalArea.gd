# GoalArea.gd
extends Area2D

signal goal_scored(side: String)

@export var side: String = "left"  # "left" or "right"

func _on_body_entered(body):
	if body.name == "Ball":
		emit_signal("goal_scored")
