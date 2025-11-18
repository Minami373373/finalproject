


extends Area2D

# Custom signal to tell the main game we've been clicked
signal player_clicked(player)

# base ability scores
@export var move_skill: int = 10
@export var pass_skill: int = 10
@export var shoot_skill: int = 10
@export var tackle_skill: int = 10

@export var is_team_a: bool = true

var has_ball: bool = false

# emit this when action (move, pass) is done
signal action_finished

@onready var label = $Label

func _ready():
	# Make teams different colors
	if is_team_a:
		$Sprite2D.modulate = Color(0.5, 0.5, 1.0) # Blue
	else:
		$Sprite2D.modulate = Color(1.0, 0.5, 0.5) # Red

	label.text = "P" 

# detect clicks
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print ("hello")
		player_clicked.emit(self)

# ---Action Functions ---

func select():
	# visual feedback for selection
	$Sprite2D.scale = Vector2(1.2, 1.2)
	label.text = "Selected"

func deselect():
	$Sprite2D.scale = Vector2(1.0, 1.0)
	label.text = "P"

func move_to(target_position: Vector2):
	label.text = "Moving..."
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 1.0)
	# When the tween finishes, emit the signal
	tween.tween_callback(func(): emit_signal("action_finished"))

func pass_to(target_position: Vector2, ball: Area2D):
	label.text = "Passing..."
	has_ball = false
	ball.holder = null

	var roll = randi_range(1, 20)
	var dc = 15 #Difficulty Class
	var total_skill = roll + pass_skill

	print("Pass attempt: Rolled %d + %d skill = %d. (Need %d)" % [roll, pass_skill, total_skill, dc])

	var final_pos = target_position
	if total_skill >= dc:
		print("Pass success!")
		# In a full game, revise the pass code so that player passes to a *player*, not a position.
	else:
		print("Pass failed!")
		# Scatter the ball randomly nearby
		final_pos += Vector2(randf_range(-50, 50), randf_range(-50, 50))

	# Use a tween to show the ball moving, then finish the action
	var tween = get_tree().create_tween()
	tween.tween_property(ball, "global_position", final_pos, 0.5)
	tween.tween_callback(func(): emit_signal("action_finished"))

func shoot_at(goal_position: Vector2, ball: Area2D):
	# For the prototype, this will be identical to pass_to.
	# You can build out the different logic later.
	label.text = "Shooting!"
	has_ball = false
	ball.holder = null

	var roll = randi_range(1, 20)
	var dc = 18 # Maybe shooting is harder?
	var total_skill = roll + shoot_skill
	print("Shoot attempt: Rolled %d + %d skill = %d. (Need %d)" % [roll, shoot_skill, total_skill, dc])

	var final_pos = goal_position
	if total_skill < dc:
		final_pos += Vector2(randf_range(-100, 100), randf_range(-100, 100))

	var tween = get_tree().create_tween()
	tween.tween_property(ball, "global_position", final_pos, 0.7)
	tween.tween_callback(func(): emit_signal("action_finished"))
	
# Player.gd


func _on_label_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
