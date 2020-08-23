extends KinematicBody2D

const PLAYER_HURT_SOUND   = preload("res://Scenes/PlayerHurtSound.tscn")
const ACCELERATION        = 500
const MAX_SPEED           = 80
const ROLL_SPEED          = 120
const FRICTION            = 500
const INVINCIBLE_DURATION = 0.6

enum {MOVE, ROLL, ATTACK}

var state       = MOVE
var velocity    = Vector2.ZERO
var rollVector  = Vector2.DOWN

# PlayerStats is autoloaded - see project Settings -> Autoload tab
var stats       = PlayerStatsNode


#var animationPlayer = null
#OR:
onready var animationPlayer      = $AnimationPlayer
onready var animationTree        = $AnimationTree
onready var animationState       = animationTree.get("parameters/playback")
onready var swordHitBox          = $HitboxPivot/SwordHitbox
onready var playerHurtbox        = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	# initialise Idle, Run, Attack, and Roll to all be to the the same direction - as per rollVector..
	animationTree.set ("parameters/Idle/blend_position",    rollVector)
	animationTree.set ("parameters/Run/blend_position",     rollVector)
	animationTree.set ("parameters/Attack/blend_position",  rollVector)
	animationTree.set ("parameters/Roll/blend_position",    rollVector)

	stats.connect ("no_health", self, "queue_free")
	
	# set the default animation state
	animationTree.active = true
	animationState.travel("Idle")
	swordHitBox.knockBackVector = rollVector
#	animationPlayer = $AnimationPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
# This function is called every frame, as often as possible.  delta is NOT constant !
#func _process(delta):
#	pass

# delta is constant
# If you aren't doing physics, just use _process ()
#move_and_slide uses physics -> probably best to use _physics_process()
func _physics_process(delta):
#func _process(delta):
	if (state == MOVE):
		move_state(delta)
	elif (state == ROLL):
		roll_state()
	elif (state == ATTACK):
		attack_state()
	
	# OR use a match - like a switch / case stateement.
	# match state:
	# 	MOVE:
	#		move_state(delta)
	#	ROLL:
	#		roll_state()
	#	ATTACK:
	#		attack_state()
	

func move_state(delta):	
	var inputVector = Vector2.ZERO
	
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Ensure we don't exceed MAX_SPEED in any direction.  e.g. diagonals aren't faster.
	inputVector = inputVector.normalized()
	
	if (inputVector != Vector2.ZERO):
		# Player is moving / accelerating
		rollVector = inputVector
		swordHitBox.knockBackVector = rollVector

		#if (inputVector.x > 0):
		#	animationPlayer.play("Run_Right")
		#else:
		#	animationPlayer.play("Run_Left")
		
		# only update Blend Position when we are moving - so we continue to face in the right direction 
		# for Idle animations when we stop.
		animationTree.set ("parameters/Idle/blend_position",    inputVector)
		animationTree.set ("parameters/Run/blend_position",     inputVector)
		animationTree.set ("parameters/Attack/blend_position",  inputVector)
		animationTree.set ("parameters/Roll/blend_position",    inputVector)
		
		animationState.travel("Run")

		velocity = velocity.move_toward (inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		# Player is coasting / slowing down
		#animationPlayer.play("Idle_Right")
		velocity = velocity.move_toward (Vector2.ZERO, FRICTION * delta)

		animationState.travel("Idle")
		
	move()

	if Input.is_action_just_pressed("roll"):
		# For testing of HealthUI
		#PlayerStatsNode.maxHealth -= 1
	
		state = ROLL
			
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = rollVector * ROLL_SPEED
	animationState.travel("Roll")
	move()
		
func attack_state():
	#animationPlayer.play ("Attack_Right")
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func move():
	velocity = move_and_slide (velocity)
	
func roll_animation_finished():
	# Called in the Animation Player when the attack animation is finished.
	
	velocity = velocity * 0.8
	state = MOVE
	
func attack_animation_finished():
	# Called in the Animation Player when the attack animation is finished.
	state = MOVE
	


func _on_Hurtbox_area_entered(area):
	#stats.healthRemaining -= 1
	stats.healthRemaining -= area.damageDone
	playerHurtbox.start_invincibility (INVINCIBLE_DURATION)
	playerHurtbox.create_hit_effect()
	
	var playerHurtSound = PLAYER_HURT_SOUND.instance()
	get_tree().current_scene.add_child (playerHurtSound)
	


func _on_Hurtbox_invinciblity_started():
	blinkAnimationPlayer.play("Start")
	pass # Replace with function body.


func _on_Hurtbox_invinciblity_ended():
	blinkAnimationPlayer.play("Stop")
	pass # Replace with function body.
