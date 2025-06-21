extends Node2D

@export var body_scene : PackedScene  # Assign CelestialBody.tscn in Inspector
@export var default_mass := 1000.0
@export var planet_stable_scene : PackedScene
@onready var buttonchecked: bool = $UI/Control/VBoxContainer/HBoxContainer3/CheckBox.button_pressed

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept") and buttonchecked == false:
		var new_body = body_scene.instantiate()
		new_body.global_position = get_global_mouse_position()
		new_body.mass = default_mass
		add_child(new_body)
	elif buttonchecked == true:
		var new_stable = planet_stable_scene.instantiate()
		new_stable.global_position = get_global_mouse_position()
		new_stable.mass = default_mass
		add_child(new_stable)
