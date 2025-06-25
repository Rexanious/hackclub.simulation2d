extends Node2D
const G:= 1000.0
@export var body_scene : PackedScene
@export var default_mass := 10000.0
@export var planet_stable_scene : PackedScene
@onready var velocity_ui = $UI/Control
@onready var speed = $UI/Control/SpeedSlider.value
var max_distance := 5000.0
var delete_mode := false
var hovered_planet: RigidBody2D = null
@onready var label = Label.new()

func _ready():
	$UI/Control/DeleteButton.toggled.connect(_on_delete_button_toggled)
	update_cursor()
	add_child(label)
	label.add_theme_font_size_override("font_size", 24)
	label.position = Vector2(20, 20)

func _physics_process(_delta):
	if delete_mode:
		check_planet_hover()
	var mouse_pos = get_global_mouse_position()
	var nearest_planet = get_nearest_planet(mouse_pos)
	
	if nearest_planet:
		var distance = mouse_pos.distance_to(nearest_planet.global_position)
		var orbital_velocity = calculate_orbital_velocity(nearest_planet.mass, distance)
		print("Orbital velocity needed: ", orbital_velocity, " px/s")
		label.text = "Orbital Velocity: %.1f px/s" % orbital_velocity

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_planet"):
		var new_body = body_scene.instantiate()
		new_body.global_position = get_global_mouse_position()
		new_body.mass = default_mass
		new_body.linear_velocity = velocity_ui.velocity_vector
		add_child(new_body)
	if event.is_action_pressed("spawn_sun"):
		var new_sun = planet_stable_scene.instantiate()
		new_sun.global_position = get_global_mouse_position()
		new_sun.mass = default_mass
		add_child(new_sun)

func _on_delete_button_toggled(is_pressed: bool):
	delete_mode = is_pressed
	update_cursor()
	
	if delete_mode:
		print("Delete mode activated")
	else:
		print("Delete mode deactivated")
		hovered_planet = null

func update_cursor():
	if delete_mode:
		Input.set_custom_mouse_cursor(preload("res://images/cursor_delete.png"), Input.CURSOR_ARROW, Vector2(40, 40))
	else:
		Input.set_custom_mouse_cursor(null)

func _input(event):
	if delete_mode and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if hovered_planet:
				delete_planet(hovered_planet)
			else:
				print("No planet selected for deletion")

func check_planet_hover():
	var mouse_pos = get_global_mouse_position()
	var new_hover = null
	
	# Find closest planet under mouse
	for planet in get_tree().get_nodes_in_group("celestial_bodies"):
		if planet.position.distance_to(mouse_pos) < planet.get_node("CollisionShape2D").shape.radius:
			new_hover = planet
			break
	
	# Update hover state
	if new_hover != hovered_planet:
		if hovered_planet:
			hovered_planet.get_node("Highlight").visible = false
		hovered_planet = new_hover
		if hovered_planet:
			hovered_planet.get_node("Highlight").visible = true

func delete_planet(planet: RigidBody2D):
	print("Deleting planet at ", planet.position)
	planet.queue_free()
	hovered_planet = null

func get_nearest_planet(position: Vector2) -> Node2D:
	var nearest = null
	var min_dist = INF
	
	for planet in get_tree().get_nodes_in_group("celestial_bodies"):
		var dist = position.distance_to(planet.global_position)
		if dist < min_dist:
			min_dist = dist
			nearest = planet
	
	return nearest

func calculate_orbital_velocity(planet_mass: float, distance: float) -> float:
	# Simple orbital velocity formula: v = sqrt(G * M / r)
	return sqrt(G * planet_mass / max(1.0, distance))

func _on_backbutton_pressed() -> void:
	SceneTransition.change_scene("res://Scenes/main_menu.tscn") # Replace with function body.
