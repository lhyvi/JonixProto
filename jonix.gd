extends CharacterBody2D

class_name Jonix

enum JonixState {
	Normal,
	Knockback
}

@export var speed: float
@export var max_jump_height : float
@export var min_jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export_range(3,10) var ghostDistance: int = 3

@onready var jump_velocity : float = ((2.0 * max_jump_height) / jump_time_to_peak) * -1.0
@onready var max_jump_gravity : float = ((-2.0 * max_jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var min_jump_gravity : float =  (jump_velocity*jump_velocity) / (2 * min_jump_height)
@onready var fall_gravity : float = ((-2.0 * max_jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var flip: bool = false
var is_jumping: bool = false
var is_dashing: bool = false
@onready var coyote_timer: Timer = $Coyote
@onready var player: Player = get_parent()

#Ghost
var past: Array = Array()
var past2: Array = Array()

var state: JonixState = JonixState.Normal

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationTree.active = true
	
func _physics_process(delta):
	match(state):
		JonixState.Normal:
			move(delta)
			if Input.is_action_pressed("debug"):
				make_knockback()
		JonixState.Knockback:
			knockback()
	update_afterimage()
	animation()



func get_frame_texture() -> Texture:
	return $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation,$AnimatedSprite2D.get_frame())

func animation():
	$AnimatedSprite2D.flip_h = flip
	$AnimationTree.set("parameters/walk/transition_request", "on" if get_x() else "off")
	$AnimationTree.set("parameters/dash/transition_request", "on" if isDash() and get_x() else "off")
	$AnimationTree.set("parameters/jump/transition_request", "on" if !is_on_floor() else "off")
	#$AnimationTree.set("parameters/has_jumped/request", 1 if hasJumped() else 0)
	$AnimationTree.set("parameters/flash/transition_request", "on" if state == JonixState.Knockback else "off")


func move(delta):
	var movement: float = get_x() * (speed * 1.5 if isDash() else speed)
	
	
	velocity.y += get_gravity() * delta
	
	if is_on_floor():
		if Input.is_action_just_pressed("move_jump"):
			jump()
	
	velocity.x = movement
	
	var was_grounded: bool = is_on_floor(); #coyote
	move_and_slide()
	if was_grounded and !is_on_floor(): #coyote
		coyote_timer.start()
	
	if movement:
		flip = movement < 0

func get_gravity() -> float:
	if velocity.y < 0.0:
		if Input.is_action_pressed("move_jump"):
			return max_jump_gravity
		return min_jump_gravity
	return fall_gravity

func jump():
	velocity.y = jump_velocity

func knockback():
	var movement: float = (1 if flip else -1) * speed
	velocity.x = movement
	move_and_slide()
	pass

func make_knockback():
	state = JonixState.Knockback
	get_tree().create_timer(.4).connect("timeout", func(): state = JonixState.Normal)

func get_x() -> float:
	return float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left"))

func isDash():
	var was_dashing = is_dashing
	is_dashing = (is_dashing and Input.is_action_pressed("move_dash")) or hasDashed()
	if was_dashing and !is_dashing:
		$DashTimer.stop()
	return is_dashing

func hasDashed():
	if Input.is_action_just_pressed("move_dash") and is_on_floor():
		$DashTimer.start()
		return 1
	return 0

func update_afterimage():
	var currentJonix: JonixAfterimage = JonixAfterimage.new(self)
	past.push_front(currentJonix)
	
	if isDash() && past.size() < ghostDistance:
		past.resize(ghostDistance)
		past.fill(currentJonix)
		
	if past.size() > ghostDistance or !isDash():
		var pastJonix: JonixAfterimage
		
		if past.size() > 0:
			pastJonix = past.pop_back()
		else:
			pastJonix = currentJonix
		
		pastJonix.paste($Ghost)
		past2.push_front(pastJonix)
		if !isDash() and past.size() > 0:
			past.pop_back()
			
	if past2.size() > ghostDistance or !isDash():
		var pastJonix: JonixAfterimage
		
		if past2.size() > 0:
			pastJonix = past2.pop_back()
		else:
			pastJonix = currentJonix
		
		pastJonix.paste($Ghost2)
		if !isDash() and past2.size() > 0:
			past2.pop_back()

func collision():
	pass
	#for i in get_slide_collision_count():
		#var collider = get_slide_collision(i)
		#if collider.get_collider().is_in_group("Enemy"):
		#	var enemy: Enemy = collider.get_collider()
		#	enemy.take_damage(.5)


func _on_dash_timer_timeout():
	is_dashing = false
