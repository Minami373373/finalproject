extends Node2D

var score_left := 0
var score_right := 0

func _ready():
	pass

func _on_goal_scored(side):
	print("hello")
	if side == "left":
		score_right += 1   # Right team scored on left goal
	else:
		score_left += 1    # Left team scored on right goal
	update_scoreboard()
	
func reset_ball():
	$Ball.global_position = Vector2(576,324) 
	$Ball.stop_dribble.call_deferred()

func update_scoreboard():
	$CanvasLayer/Score.text = str(score_left, " : ", score_right)
	
	reset_ball()


func _on_goal_left_body_entered(body: Node2D) -> void:
	emit_signal("goal_scored")


func _on_goal_left_goal_scored(side: String) -> void:
	pass # Replace with function body.
