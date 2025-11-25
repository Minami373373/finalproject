extends Node2D

var score_left := 0
var score_right := 0

func _ready():
	pass

func _on_goal_scored(side):
	if side == "left":
		score_right += 1   # Right team scored on left goal
	else:
		score_left += 1    # Left team scored on right goal

func reset_ball():
	$Ball.global_position = Vector2(576,324) 
	$Ball.stop_dribble()

func update_scoreboard():
	$CanvasLayer/LabelScore.text = str(score_left, " : ", score_right)

	update_scoreboard()
	reset_ball()
