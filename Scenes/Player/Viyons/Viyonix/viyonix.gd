extends RayCast2D

signal hit(body: Node2D)

var is_shooting := false

func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[0] = Vector2.ZERO
	$Line2D.points[1] = Vector2.ZERO

func _physics_process(delta) -> void:
	var cast_point := target_position
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
	$Line2D.points[1] = cast_point
	
	var collider = get_collider()
	if collider:
		hit.emit(collider)
		

func set_is_shooting(shooting: bool) -> void:
	if is_shooting == shooting:
		return
	is_shooting = shooting
	if is_shooting:
		show_ray()
	else:
		hide_ray()
	set_physics_process(shooting)

func show_ray() -> void:
	$Line2D.visible = true
	pass
func hide_ray() -> void:
	$Line2D.visible = false
	pass
