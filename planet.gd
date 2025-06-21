extends RigidBody2D

@export var initial_velocity := Vector2(0, 100)
var G := 2000.0

func _ready():
	add_to_group("celestial_bodies")
	linear_velocity = initial_velocity
	gravity_scale = 0.0  # Disable default gravity
	$Sprite2D.scale = Vector2.ONE * sqrt(mass) * 0.03
	$CollisionShape2D.scale = Vector2.ONE * sqrt(mass) * 0.489
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_collision)
func _physics_process(delta):
	var bodies = get_tree().get_nodes_in_group("celestial_bodies")
	var total_force := Vector2.ZERO
	for body in bodies:
		if body == self: continue
		var dir = (body.global_position - global_position).normalized()
		var dist_sq = global_position.distance_squared_to(body.global_position)
		total_force += dir * (G * mass * body.mass) / dist_sq
	apply_central_force(total_force * delta * 60.0)

func _on_collision(body: Node):

	apply_central_impulse(-linear_velocity * 0.7)
