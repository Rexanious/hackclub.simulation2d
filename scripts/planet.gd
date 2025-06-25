extends RigidBody2D
var G := 1000.0
var fixed_delta := 1.0 / 60.0  # Fixed physics timestep
var scalemass = 0.0003
var scalecollision = 0.00489

func _ready():
	add_to_group("celestial_bodies")
	gravity_scale = 0.0
	contact_monitor = true
	$Sprite2D.scale = Vector2.ONE * sqrt(mass) * scalemass
	$CollisionShape2D.scale = Vector2.ONE * sqrt(mass) * scalecollision
	$Highlight.scale = Vector2.ONE * sqrt(mass) * 0.003
	max_contacts_reported = 1
	body_entered.connect(_on_collision)
func _physics_process(delta):
	
	var effective_delta = delta / Engine.time_scale
	
	# Calculate physics using fixed timestep ratio
	var physics_steps = ceil(effective_delta / fixed_delta)
	var step_delta = effective_delta / physics_steps
	
	for i in physics_steps:
		custom_physics(step_delta)

func _on_collision(body: Node):
	apply_central_impulse(-linear_velocity * 50)

func custom_physics(step_delta):
	var bodies = get_tree().get_nodes_in_group("celestial_bodies")
	var total_force := Vector2.ZERO
	for body in bodies:
		if body == self: continue
		var dir = (body.global_position - global_position).normalized()
		var dist_sq = global_position.distance_squared_to(body.global_position)
		total_force += dir * (G * mass * body.mass) / dist_sq
	apply_central_force(total_force * step_delta * 60.0)
