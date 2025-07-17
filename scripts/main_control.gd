extends Control

@onready var buttons_container = $CenterContainer/VBoxContainer

func _ready():
	# Focus first button for keyboard navigation
	buttons_container.get_child(0).grab_focus()
	# Connect signals
	$CenterContainer/VBoxContainer/SandboxButton.pressed.connect(_on_sandbox_pressed)
	$CenterContainer/VBoxContainer/ChallengesButton.pressed.connect(_on_challenges_pressed)
	$CenterContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	
	# Visual polish
	animate_buttons()

func animate_buttons():
	for i in range(buttons_container.get_child_count()):
		var button = buttons_container.get_child(i)
		button.scale = Vector2(0.8, 0.8)
		var tween = create_tween()
		tween.tween_property(button, "scale", Vector2.ONE, 0.3)\
			 .set_delay(0.1 * i)\
			 .set_ease(Tween.EASE_OUT)\
			 .set_trans(Tween.TRANS_BACK)

func _on_sandbox_pressed():
	$"../Clicksound".play()
	SceneTransition.change_scene("res://Scenes/sandbox.tscn")

func _on_challenges_pressed():
	$"../Clicksound".play()
	SceneTransition.change_scene("res://Scenes/level_selection.tscn")

func _on_exit_pressed():
	$"../Clicksound".play()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_exit_pressed()

func _on_github_pressed() -> void:
	OS.shell_open("https://github.com/Rexanious/hackclub.simulation2d")


func _on_itch_pressed() -> void:
	OS.shell_open("https://rexanious.itch.io/solarbox")
