extends Control


func _on_tutorialbutton_pressed() -> void:
	$Clicksound.play()
	SceneTransition.change_scene("res://levels/tutorial.tscn")

func _on_moonbutton_pressed() -> void:
	$Clicksound.play()
	SceneTransition.change_scene("res://levels/Moon.tscn")

func _on_starbutton_pressed() -> void:
	$Clicksound.play()
	SceneTransition.change_scene("res://levels/Starnavigator.tscn")


func _on_blackholebutton_pressed() -> void:
	$Clicksound.play()
	SceneTransition.change_scene("res://levels/Blackhole.tscn")


func _on_backbutton_pressed() -> void:
	$Clicksound.play()
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
