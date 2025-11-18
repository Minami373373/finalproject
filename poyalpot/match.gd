# Match.gd
extends Node2D

enum State { 
	PLAYER_TURN_START,   # Player needs to pick a player
	PLAYER_AWAIT_ACTION, # A player is selected, waiting for button
	PLAYER_AWAIT_TARGET, # "Move" or "Pass" was clicked, waiting for click
	ACTION_IN_PROGRESS,  # An animation (tween) is playing
	AI_TURN              
}

var current_state = State.PLAYER_TURN_START

var selected_player: Node2D = null
var action_to_perform: String = "" # Will store "move", "pass", "shoot"

@onready var ball = $Ball
@onready var ui_container = $UI/HBoxContainer
@onready var players_node = $Players
@onready var goal_b = $Goals/GoalB # AI will aim here


func _ready():
	ui_container.get_node("MoveButton").pressed.connect(_on_MoveButton_pressed)
	ui_container.get_node("PassButton").pressed.connect(_on_PassButton_pressed)
	ui_container.get_node("ShootButton").pressed.connect(_on_ShootButton_pressed)

	# --- Create the Players ---
	var player_scene = preload("res://Player.tscn")

	# Team A (Player)
	for i in 5:
		var p = player_scene.instantiate()
		p.is_team_a = true
		p.position = Vector2(200, 100 + i * 100)
		p.player_clicked.connect(_on_player_clicked)
		p.action_finished.connect(_on_player_action_finished)
		players_node.add_child(p)

	# Team B (AI)
	for i in 5:
		var p = player_scene.instantiate()
		p.is_team_a = false
		p.position = Vector2(700, 100 + i * 100)
		# AI players need their signals connected in full version
		players_node.add_child(p)

	# Give the ball to the first player
	var first_player = players_node.get_child(0)
	first_player.has_ball = true
	ball.holder = first_player

	# Start the game
	change_state(State.PLAYER_TURN_START)

# Main state machine
func change_state(new_state):
	current_state = new_state
	print("New state: ", State.keys()[new_state]) 

	match current_state:
		State.PLAYER_TURN_START:
			# Deselect any old player, hide the UI
			if selected_player:
				selected_player.deselect()
				selected_player = null
			ui_container.visible = false

		State.PLAYER_AWAIT_ACTION:
			# A player is selected, show the UI
			ui_container.visible = true

		State.PLAYER_AWAIT_TARGET:
			# Waiting for a click on the field
			ui_container.visible = false 

		State.ACTION_IN_PROGRESS:
			pass

		State.AI_TURN:
			# Hide UI, run the simple AI
			ui_container.visible = false
			if selected_player:
				selected_player.deselect()
				selected_player = null

			# Start the AI 
			# use a timer so it doesn't happen instantly
			get_tree().create_timer(1.0).timeout.connect(_process_ai_turn)

# --- Input Handling ---

# This runs when any player is clicked
func _on_player_clicked(player):
	# our turn to pick a player
	if current_state != State.PLAYER_TURN_START:
		return

	# Only let us select our own team
	if not player.is_team_a:
		print("That's not your player!")
		return

	# We have a valid player
	selected_player = player
	selected_player.select()
	change_state(State.PLAYER_AWAIT_ACTION)

# This runs when the background (field) is clicked
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		#waiting for a target
		if current_state == State.PLAYER_AWAIT_TARGET:
			var target_pos = get_global_mouse_position()

			# Do the action we saved
			if action_to_perform == "move":
				selected_player.move_to(target_pos)

			elif action_to_perform == "pass":
				selected_player.pass_to(target_pos, ball)

			elif action_to_perform == "shoot":
				# AI's goal is GoalB
				selected_player.shoot_at(goal_b.global_position, ball)

			action_to_perform = "" # Clear the action
			change_state(State.ACTION_IN_PROGRESS)

# --- UI Button Functions ---, will recover once the UI problem is solved.

func _on_MoveButton_pressed():
	if current_state != State.PLAYER_AWAIT_ACTION: return

	action_to_perform = "move"
	change_state(State.PLAYER_AWAIT_TARGET)

func _on_PassButton_pressed():
	if current_state != State.PLAYER_AWAIT_ACTION: return
	if not selected_player.has_ball:
		print("You don't have the ball!")
		return

	action_to_perform = "pass"
	change_state(State.PLAYER_AWAIT_TARGET)

func _on_ShootButton_pressed():
	if current_state != State.PLAYER_AWAIT_ACTION: return
	if not selected_player.has_ball:
		print("You don't have the ball!")
		return

	action_to_perform = "shoot"
	change_state(State.PLAYER_AWAIT_TARGET)
				
# --- Signal Callbacks ---

# This runs when a player's move/pass tween finishes
func _on_player_action_finished():
	# If an action finished, it is the AI's turn
	change_state(State.AI_TURN)

# --- AI---

func _process_ai_turn():
	print("AI is 'thinking'...")

	# Find an AI player, the AI needs to be extended in full version
	var ai_player = null
	for p in players_node.get_children():
		if not p.is_team_a:
			ai_player = p
			break # Found one

	if ai_player:
		# Move 100 pixels towards the center.
		var move_target = ai_player.global_position + Vector2(-100, 0)

		# wait for the AI's move to finish
		var tween = get_tree().create_tween()
		tween.tween_property(ai_player, "global_position", move_target, 1.0)

		# When the AI's move is done, it's the player's turn again
		tween.tween_callback(func(): change_state(State.PLAYER_TURN_START))
	else:
		#  Player's turn again.
		change_state(State.PLAYER_TURN_START)
