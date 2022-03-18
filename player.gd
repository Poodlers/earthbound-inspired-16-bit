extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
const ROLL_SPEED = 1.5

enum {
	MOVE,
	ATTACK,
	ROLL
}

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.DOWN

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var swordCollison = $HitboxPivot/SwordHitbox/CollisionShape2D

func _ready():
	animationTree.active = true
	swordCollison.disabled = true
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		ROLL:
			roll_state()
		
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,  FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_state_finished():
	state = MOVE
	
func roll_state():
	velocity = roll_vector * ROLL_SPEED * MAX_SPEED
	animationState.travel("Roll")
	move()
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_state_finished():
	velocity = Vector2.ZERO
	state = MOVE
