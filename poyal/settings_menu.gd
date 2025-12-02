extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)
