extends Node

export (int)   var maxHealth    = 1
#export (float) var maxHitDamage = 1

onready var healthRemaining = maxHealth  setget set_health

signal no_health

#
# This code works, but not very optimised - you would need to check your
# health every single frame.
# Much better to use setget on the variable
#
#func _process(delta):
#	if (healthRemaining < 0):
#		emit_signal ("no_health")
	

func set_health (value):
	healthRemaining = value
	print("Health: ", healthRemaining, " / ", maxHealth)
	
	if (healthRemaining <= 0):
		emit_signal ("no_health")
	
