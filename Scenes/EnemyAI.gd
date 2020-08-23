extends KinematicBody2D

enum {IDLE, WANDER, CHASE}

const EnemyDeathEffect = preload("res://Scenes/EnemyDeathEffect.tscn")

export var ACCELERATION  = 300
export var MAX_SPEED     = 50
export var FRICTION      = 200
export var SOFT_COLLISSION_PUSH_BACK  = 400

onready var stats               = $StatsNode
onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite      = $AnimatedSprite
onready var enemyHurtbox        = $Hurtbox
onready var softCollission      = $SoftCollission
onready var wanderController    = $WanderController

var velocity  = Vector2.ZERO
var knockBack = Vector2.ZERO
var state     = IDLE
var secondsSinceLastPrint = 0.0



func _ready():
	pass
	
func _physics_process(delta):
	secondsSinceLastPrint += delta
	
	knockBack = knockBack.move_toward(Vector2.ZERO, FRICTION * delta)
	knockBack = move_and_slide(knockBack)

	match state:
		IDLE: 
			velocity = velocity.move_toward (Vector2.ZERO, FRICTION * delta)
			seek_player()
			if (wanderController.get_time_left() == 0):
				update_wandering()

		WANDER:
			seek_player()
			if (wanderController.get_time_left() == 0):
				update_wandering()

			#var directionToTarget = global_position.direction_to(wanderController.target_position)
			#velocity = velocity.move_toward (directionToTarget * MAX_SPEED, ACCELERATION * delta)
			
			accellerate_towards_point (wanderController.target_position, delta)
			
			if (global_position.distance_to(wanderController.target_position) <= ACCELERATION * delta):
				update_wandering()

		CHASE:
			var player = playerDetectionZone.player

			if (player != null):
				accellerate_towards_point (player.global_position, delta)
			#if (player != null):
			#	#var directionToPlayer = (player.global_position - global_position).normalized()
			#	var directionToPlayer = global_position.direction_to(player.global_position)
			#	velocity = velocity.move_toward (directionToPlayer * MAX_SPEED, ACCELERATION * delta)
			#else:
			#	state = IDLE
				

	#animatedSprite.flip_h = velocity.x < 0
	
	if (softCollission.is_colliding() == true):
		velocity += softCollission.get_push_vector() * delta * SOFT_COLLISSION_PUSH_BACK
		
	velocity = move_and_slide(velocity)
	
	if (secondsSinceLastPrint > 1.0):
		secondsSinceLastPrint = 0.0
		#print (state)

func update_wandering():
	state = pick_random_state ([IDLE, WANDER])
	wanderController.start_wander_timer(3)


func accellerate_towards_point(position, delta):
		if (position != null):
			var directionToTarget = global_position.direction_to(position)
			velocity = velocity.move_toward (directionToTarget * MAX_SPEED, ACCELERATION * delta)
		else:
			state = IDLE
			
		animatedSprite.flip_h = velocity.x < 0
		
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state (state_list):
	state_list.shuffle()
	return state_list.pop_front()
	

func _on_Hurtbox_area_entered(area):
	#var knockBackVector = area.knockBack
	#knockBack = Vector2.RIGHT * 120
	knockBack = area.knockBackVector * 120
	
	#
	# The code below works fine ... but we can use signals and method calls
	# Godot rule of thumb: call down / signal up
	#
	#print(stats.healthRemaining, " / ", stats.maxHealth)
	#stats.healthRemaining -= 1
	#if (stats.healthRemaining <= 0):
	#	queue_free()
	
	# damageDone from the Hitbox script
	#stats.healthRemaining -= 1
	stats.healthRemaining -= area.damageDone
	enemyHurtbox.create_hit_effect()


func _on_StatsNode_no_health():
	queue_free()
	
	# Add the EnemyDeathEffect to the same tree level as the Enemy
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
