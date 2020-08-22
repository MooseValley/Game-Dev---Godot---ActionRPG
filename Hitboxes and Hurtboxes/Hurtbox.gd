extends Area2D

#export (bool) var showHitEffect = true

const HitEffect = preload("res://Scenes/HitEffect.tscn")

onready var timer = $Timer

var invincible  = false setget set_invincible

signal invinciblity_started
signal invinciblity_ended


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_invincible (value):
	invincible = value
	if (invincible == true):
		emit_signal ("invinciblity_started")
	else:
		emit_signal ("invinciblity_ended")

func start_invincibility (duration):
	self.invincible  = true
	timer.start (duration)


#func _on_Hurtbox_area_entered(area):
func create_hit_effect():
	#if (showHitEffect == true):
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position # - Vector2(0, 8)


func _on_Timer_timeout():
	# Must use "self." here otherwise the setter will get called in an infinite loop
	self.invincible  = false


func _on_Hurtbox_invinciblity_started():
	# Collissions are no longer monitored
	# This code gives error message: "E 0:00:02.841   set_monitorable: Function blocked during in/out signal. 
	# Use set_deferred("monitorable", true/false).
	# Probably because it is set during the physics process ...  So use set_deferred as the error suggests.
	#monitorable = false
	set_deferred("monitorable", false)
	


func _on_Hurtbox_invinciblity_ended():
	# Collissions are monitored again and this
	monitorable = false
