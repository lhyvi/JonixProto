extends Viyon
#var max_ammo: float = 10
#static var ammo: float = 10
#static var first_summon: bool = true

func _ready():
	preamble()
#	if first_summon:
#		first_summon = false
#		ammo = max_ammo
	
	
func _process(delta):
#	if Input.is_action_just_pressed("reload"): ammo = max_ammo
	flip()	
	follow_jonix()
	$Viyonix.set_is_shooting(is_attack)
	

func attack():
#	if ammo > 0:
	is_attack = true
#		ammo -= 1
#	print(ammo)

func attack_release():
	is_attack = false
