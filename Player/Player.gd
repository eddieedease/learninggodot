extends KinematicBody2D

# Main VARS

const MAX_SPEED = 120;
const ACCELERATION = 500;
const FRICTION = 900;


var velocity = Vector2.ZERO


# State machine - enumaration CONST (0,1,2,3)
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

# shorthand for _ready when loaded
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	#animationtree active = on, so we can turn it off in the 
	animationTree.active = true


# Runs every single physics step (every frame?)
# Player Input
func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

# move State
func move_state(delta):
	# get a x 1,-1 y 1,-1 position in input_vector. We are going to use this for player input
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#normalize input_vector
	input_vector = input_vector.normalized()
	
	# if is moving vs not moving
	# works with the blendspace2d from the AnimationTree
	if (input_vector != Vector2.ZERO):
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run");
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else :
		animationState.travel("Idle");
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	# move_and_collide(velocity * delta); 
	# move_and_slide no longer need delta, and update current velocity
	velocity = move_and_slide(velocity);
	
	# input event state changes
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = MOVE

