class_name Viyon extends CharacterBody2D

enum AttackType {
	PRESS,
	HOLD
}

## Used for character weapons / Viyons
## add _on_attack_done() to end of attack animations

@export_category("Main")
@export var damage: float = 10
@export var attack_type: AttackType

@export_category("Extras")
@export var offset_x: float = -15
@export var offset_y: float = -30
@export var float_off: float = 0
@export var min_speed: float = 10

@export_category("AnimationPlayer用")
@export var can_attack: bool = true
@export var is_attack: bool = false
@export var is_disappear: bool = false
@onready var jonix: Jonix = $"../Jonix"

func attack():
	pass

func attack_release():
	pass

func _process(delta):
	if is_disappear:
		return
	if can_attack:
		flip()
	follow_jonix()

func _ready():
	preamble()

func disappear() -> void:
	is_disappear = true
	$AnimationTree.set("parameters/disappear/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	pass

func set_pos(pos: Vector2) -> void:
	self.position = pos

func preamble() -> void:
	$AnimationTree.active = true

func _on_attack_hit(body: Node2D) -> void:
	pass
#	if body is Viyonite:
#		body = body as Viyonite
#		body.take_damage(damage)

func _on_attack_done() -> void:
	can_attack = true

func flip() -> void:
	var flip
	if jonix.flip:
		flip = jonix.flip
	else:
		flip = false
	
	scale.y = -1 if flip else 1
	rotation_degrees = 180 if flip else 0


func follow_jonix() -> void:
	velocity = (direction_to_jonix() * max(jonix_distance() * 5, min_speed)) + Vector2(0, float_off * 5)
	move_and_slide()

func direction_to_jonix() -> Vector2:
	return (jonix.position + offset() - position).normalized()

func jonix_distance() -> float:
	return (jonix.position + offset() - position).length()

func offset() -> Vector2:
	return Vector2(-offset_x if jonix.flip else offset_x, offset_y)




