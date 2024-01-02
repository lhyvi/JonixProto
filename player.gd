class_name Player extends Node2D
## Groups the Player and Viyons together
## Mainly manages the viyon states


## Current Viyon equipped
var viyon: Viyon
## Array of viyons available to the player
@export var viyons: Array[PackedScene]
## Index of the current viyon the player is equipped with
@export var current_viyon := 0 :
	set(value):
		current_viyon = value % viyons.size()

func _ready():
	change_viyon()
	
func _process(delta):
	var AttackType = viyon.AttackType
	
	if Input.is_action_just_pressed("switch_left"):
		current_viyon -= 1
		change_viyon()
	if Input.is_action_just_pressed("switch_right"):
		current_viyon += 1
		change_viyon()
		
	if Input.is_action_just_pressed("attack"):
		$Jonix/DashTimer.stop()
		$Jonix/DashTimer.emit_signal("timeout")
		$Jonix/AnimationTree.set("parameters/point/request",  
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		viyon.attack()
	$Jonix/AnimationTree.set("parameters/pointing/transition_request",  
			"on" if Input.is_action_pressed("attack") and viyon.is_attack else "off")
			
	if Input.is_action_just_released("attack"):
		viyon.attack_release()
	
	

func change_viyon():
	if viyon:
		viyon.disappear()
	viyon = viyons[current_viyon].instantiate() as Viyon
	add_child(viyon)
	#move_child(viyon, 0)
	viyon.set_pos(jonix_position())

func jonix_position() -> Vector2:
	return $Jonix.position
