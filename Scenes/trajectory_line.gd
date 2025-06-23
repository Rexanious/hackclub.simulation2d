extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	width = 2
	default_color = Color(0.8, 0.8, 1.0, 0.7)
	antialiased = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
