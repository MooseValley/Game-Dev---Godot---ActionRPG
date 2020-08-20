extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED    = 80
const FRICTION     = 500

var velocity = Vector2.ZERO
#var animationPlayer = null
#OR:
onready var animationPlayer = $AnimationPlayer
onready var animationTree   = $AnimationTree
onready var animationState  = animationTree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	# set the default animation state
	animationState.travel("Idle")
#	animationPlayer = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var inputVector = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Ensure we don't exceed MAX_SPEED in any direction.  e.g. diagonals aren't faster.
	inputVector = inputVector.normalized()
	
	if (inputVector != Vector2.ZERO):
		# Player is moving / accelerating

		#if (inputVector.x > 0):
		#	animationPlayer.play("Run_Right")
		#else:
		#	animationPlayer.play("Run_Left")
		
		# only update Blend Position when we are moving - so we continue to face in the right direction 
		# for Idle animations when we stop.
		animationTree.set ("parameters/Idle/blend_position", inputVector)
		animationTree.set ("parameters/Run/blend_position",  inputVector)
		
		animationState.travel("Run")

		velocity = velocity.move_toward (inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Player is coasting / slowing down
		#animationPlayer.play("Idle_Right")
		velocity = velocity.move_toward (Vector2.ZERO, FRICTION * delta)

		animationState.travel("Idle")
		
	velocity = move_and_slide (velocity)
	
