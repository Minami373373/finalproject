extends Area2D

# hold the Player node that currently controls the ball
var holder: Node2D = null

func _process(delta):
	# If a player is holding the ball, just follow them
	if holder:
		global_position = holder.global_position

# use a Tween to move the ball smoothly
func move_to(target_position: Vector2):
	holder = null # No one is holding it while it moves
	var tween = get_tree().create_tween()
	# Move from current position to target over 0.5 seconds
	tween.tween_property(self, "global_position", target_position, 0.5).set_trans(Tween.TRANS_QUAD)
