extends KinematicBody2D

const FRICTION = 200

onready var stats = $StatsNode

var knockBack = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(delta):
	knockBack = knockBack.move_toward(Vector2.ZERO, FRICTION * delta)
	knockBack = move_and_slide(knockBack)
	
	
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


func _on_StatsNode_no_health():
	queue_free()
