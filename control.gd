extends Control

@onready var pause_button = $VBoxContainer/HBoxContainer/PauseButton
@onready var play_button = $VBoxContainer/HBoxContainer/PlayButton

@onready var mass_slider = $VBoxContainer/MassSlider
@onready var mass_label = $VBoxContainer/MassLabel

@onready var speed_1x = $VBoxContainer/HBoxContainer2/Speed1x
@onready var speed_2x = $VBoxContainer/HBoxContainer2/Speed2x
@onready var speed_05x = $VBoxContainer/HBoxContainer2/Speed05x
@onready var speed_50x = $VBoxContainer/HBoxContainer2/Speed50x

func _ready():
	pause_button.pressed.connect(_on_pause_pressed)
	play_button.pressed.connect(_on_play_pressed)
	
	mass_slider.value_changed.connect(_on_mass_changed)
	mass_slider.value = 1000  # Default mass
	
	speed_1x.pressed.connect(_on_speed_1x_pressed)
	speed_2x.pressed.connect(_on_speed_2x_pressed)
	speed_05x.pressed.connect(_on_speed_05x_pressed)
	speed_50x.pressed.connect(_on_speed_50x_pressed)

func _on_pause_pressed():
	Engine.time_scale = 0.0

func _on_play_pressed():
	Engine.time_scale = 1.0 



func _on_mass_changed(value: float):
	mass_label.text = "Mass: %d" % value
	# Share the mass value with the Main script
	get_node("/root/Main").default_mass = value



func _on_speed_1x_pressed():
	Engine.time_scale = 1.0

func _on_speed_2x_pressed():
	Engine.time_scale = 2.0

func _on_speed_05x_pressed():
	Engine.time_scale = 0.5

func _on_speed_50x_pressed():
	Engine.time_scale = 50
