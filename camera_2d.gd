extends Camera2D

var drag_start := Vector2.ZERO

func _unhandled_input(event):
	# Pan camera with middle mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				drag_start = event.position
			else:
				drag_start = Vector2.ZERO
	elif event is InputEventMouseMotion and drag_start != Vector2.ZERO:
		position -= (event.position - drag_start) * zoom
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 0.9
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 1.1
