extends Viyon
var test: Player

enum AttackState {
	Normal,
	Attack1,
	Attack2
}
var stateMax = AttackState.size() - 1

var currentAttack: AttackState = AttackState.Normal
var nextAttack: AttackState = AttackState.Normal

func attack():
	if can_attack:
		match(currentAttack):
			0:
				nextAttack = currentAttack + 1
				call_attack()
			stateMax:
				nextAttack = 0
			_:
				nextAttack = currentAttack + 1
	print(currentAttack)
func _on_attack_done():
	currentAttack = 0
	call_attack()
	
func call_attack():
	match(nextAttack):
		AttackState.Attack1:
			$AnimationTree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		AttackState.Attack2:
			$AnimationTree.set("parameters/attack2/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	currentAttack = nextAttack
	nextAttack = 0
