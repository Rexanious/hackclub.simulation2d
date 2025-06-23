extends Control

@onready var pause_button = $VBoxContainer/HBoxContainer/PauseButton
@onready var play_button = $VBoxContainer/HBoxContainer/PlayButton

@onready var mass_slider = $VBoxContainer/MassSlider
@onready var mass_label = $VBoxContainer/MassLabel

@onready var speed_1x = $VBoxContainer/HBoxContainer2/Speed1x
@onready var speed_2x = $VBoxContainer/HBoxContainer2/Speed2x
@onready var speed_05x = $VBoxContainer/HBoxContainer2/Speed05x
@onready var speed_50x = $VBoxContainer/HBoxContainer2/Speed50x

@onready var direction_slider = $DirectionSlider
@onready var speed_slider = $SpeedSlider
@onready var direction_label = $DirectionLabel
@onready var speed_label = $SpeedLabel
@onready var preview_arrow = $PreviewArrow
@onready var Volume_label = $Volume_label

var velocity_vector := Vector2.ZERO

func _ready():
	
	pause_button.pressed.connect(_on_pause_pressed)
	play_button.pressed.connect(_on_play_pressed)
	
	mass_slider.value_changed.connect(_on_mass_changed)
	mass_slider.value = 1000  # Default mass
	
	speed_1x.pressed.connect(_on_speed_1x_pressed)
	speed_2x.pressed.connect(_on_speed_2x_pressed)
	speed_05x.pressed.connect(_on_speed_05x_pressed)
	speed_50x.pressed.connect(_on_speed_50x_pressed)
	
	direction_slider.min_value = 0
	direction_slider.max_value = 360
	direction_slider.step = 1
	direction_slider.value = 0
	
	speed_slider.min_value = 0
	speed_slider.max_value = 3000
	speed_slider.step = 10
	speed_slider.value = 0
	
	direction_slider.value_changed.connect(update_velocity)
	speed_slider.value_changed.connect(update_velocity)
	
	update_velocity(0)
	

func _on_pause_pressed():
	Engine.time_scale = 0.0

func _on_play_pressed():
	Engine.time_scale = 1.0 

func _on_mass_changed(value: float):
	mass_label.text = "Mass: %d" % value
	get_node("/root/Main").default_mass = value

func _on_volume_changed(value: float):
	Volume_label.text = "volume: %d" % value
	get_node("/planet/sprite2D").default_volume = value
	get_node("/planet/Collisionshape2D").default_volume = value

func _on_speed_1x_pressed():
	Engine.time_scale = 1.0

func _on_speed_2x_pressed():
	Engine.time_scale = 2.0

func _on_speed_05x_pressed():
	Engine.time_scale = 0.5

func _on_speed_50x_pressed():
	Engine.time_scale = 50

func update_velocity(_value):
	# Convert direction to radians
	var angle_rad = deg_to_rad(direction_slider.value)
	var speed = speed_slider.value
	
	velocity_vector = Vector2(cos(angle_rad), sin(angle_rad)) * speed
	
	direction_label.text = "Direction: %d°" % direction_slider.value
	
	speed_label.text = "Speed: %d px/s" % speed_slider.value
	
	preview_arrow.rotation = angle_rad
