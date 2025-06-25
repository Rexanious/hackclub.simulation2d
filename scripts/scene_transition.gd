extends CanvasLayer


func ready():
	layer = 128


func change_scene(path: String):
	get_tree().change_scene_to_file(path)
