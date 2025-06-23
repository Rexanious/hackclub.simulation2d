extends RigidBody2D

var G := 1000.0

func _ready():
	add_to_group("celestial_bodies")
	gravity_scale = 0.0
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_collision)
	freeze = true
func _physics_process(delta):
	linear_velocity = Vector2(0, 0)

func _on_collision(body: Node):

	apply_central_impulse(-linear_velocity * 2)
