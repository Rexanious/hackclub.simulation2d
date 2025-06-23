extends Node2D

@export var body_scene : PackedScene  # Assign CelestialBody.tscn in Inspector
@export var default_mass := 10000.0
@export var planet_stable_scene : PackedScene
@onready var velocity_ui = $UI/Control
@onready var trajectory_line = $TrajectoryLine
@onready var speed = $UI/Control/SpeedSlider.value 
var prediction_cooldown := 0.0
var prediction_steps := 200
var prediction_delta := 0.1
var max_distance := 5000.0
var trajectory_visible := true
var delete_mode := false
var hovered_planet: RigidBody2D = null

func _ready():
	$UI/Control/DeleteButton.toggled.connect(_on_delete_button_toggled)
	update_cursor()
	trajectory_line.default_color = Color(0.8, 0.8, 1.0, 0.7)
	trajectory_line.width = 2.0
	trajectory_line.antialiased = true

func _physics_process(_delta):
	# Update hover detection
	if delete_mode:
		check_planet_hover()
	if trajectory_visible:
		update_trajectory()
	if !trajectory_visible: 
		return
	# Only update trajectory every 3 frames
	prediction_cooldown += _delta
	if prediction_cooldown > 0.05:  # 20 updates per second
		prediction_cooldown = 0.0
		update_trajectory()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn_planet"):
		var new_body = body_scene.instantiate()
		new_body.global_position = get_global_mouse_position()
		new_body.mass = default_mass
		new_body.linear_velocity = velocity_ui.velocity_vector
		add_child(new_body)
		if trajectory_visible:
			update_trajectory()
	if event.is_action_pressed("spawn_sun"):
		var new_sun = planet_stable_scene.instantiate()
		new_sun.global_position = get_global_mouse_position()
		new_sun.mass = default_mass
		add_child(new_sun)

func _on_delete_button_toggled(is_pressed: bool):
	delete_mode = is_pressed
	update_cursor()
	
	# Visual feedback
	if delete_mode:
		print("Delete mode activated")
	else:
		print("Delete mode deactivated")
		hovered_planet = null

func update_cursor():
	if delete_mode:
		Input.set_custom_mouse_cursor(preload("res://images/cursor_delete.png"), Input.CURSOR_ARROW, Vector2(100, 100))
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
	# Remove planet
	planet.queue_free()
	hovered_planet = null

func update_trajectory():
  # Clear previous points
	trajectory_line.clear_points()
	
	# Starting position (mouse position)
	var start_pos := get_global_mouse_position()
	trajectory_line.add_point(start_pos)
# Get initial velocity from your velocity control
	var initial_velocity: Vector2 = get_node("planet").velocity  # Replace with your actual velocity source
	
	# Get planet mass (use default or from UI)
	var mass := 1000.0  # Replace with actual mass if available
	
	# Simulation variables
	var position := start_pos
	var velocity := initial_velocity
	
	# Simulate trajectory
	for i in range(prediction_steps):
		# Calculate gravitational acceleration from all planets
		var acceleration := Vector2.ZERO
		
		for planet in get_tree().get_nodes_in_group("planets"):
			# Skip planets without position or mass
			if !is_instance_valid(planet) or !planet.has_method("get_position"):
				continue
				
			var planet_pos = planet.global_position
			var planet_mass = planet.mass if planet.has_method("get_mass") else 1000.0
			
			# Calculate direction and distance
			var dir = planet_pos - position
			var distance_squared = dir.length_squared()
			
			# Avoid division by zero
			if distance_squared < 1.0:
				distance_squared = 1.0
				
			# Calculate gravitational acceleration
			var force_magnitude = 1000.0 * planet_mass / distance_squared
			acceleration += dir.normalized() * force_magnitude
		
		# Update physics
		velocity += acceleration * 0.1
		position += velocity * 0.1
		
		# Add point to trajectory
		trajectory_line.add_point(position)
		
		# Stop if we've gone too far
		if position.distance_to(start_pos) > 2000:
			break
