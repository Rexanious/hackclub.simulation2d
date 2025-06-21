extends Node2D

@export var planet_scene : PackedScene
@export var max_planet_size : float = 100.0
@export var min_planet_size : float = 20.0

var current_radius : float = 50.0
var spawn_position : Vector2
var can_spawn := false
@onready var preview := $Preview

func _process(delta):
	if Input.is_action_pressed("spawn_mode"):
		spawn_position = get_global_mouse_position()
		preview.position = spawn_position
		preview.size = Vector2(current_radius, current_radius) * 2
		preview.visible = true
		can_spawn = true
	else:
		preview.visible = false
		can_spawn = false

func _input(event):
	if can_spawn and event.is_action_pressed("confirm_spawn"):
		spawn_planet()

func spawn_planet():
	var new_planet = planet_scene.instantiate()
	new_planet.position = spawn_position
	new_planet.mass = current_radius * 10  # Adjust multiplier as needed
	get_parent().add_child(new_planet)
