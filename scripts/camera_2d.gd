extends Camera2D

@export var speed = 100

func _input(InputEvent):
	var direction = Input.get_vector("left", "right", "up", "down")
	position += direction * speed

func _unhandled_input(event):
	# Pan camera with middle mouse
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 0.9
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 1.1
