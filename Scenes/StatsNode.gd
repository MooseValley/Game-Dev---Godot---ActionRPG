extends Node

#export (float) var maxHitDamage = 1
export (int)  var maxHealth        = 1          setget set_max_health
#onready       var healthRemaining  = maxHealth  setget set_health
var healthRemaining  = maxHealth  setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.healthRemaining  = maxHealth


# This code works, but not very optimised - you would need to check your
# health every single frame.
# Much better to use setget on the variable
#
#func _process(delta):
#	if (healthRemaining < 0):
#		emit_signal ("no_health")

func set_max_health	(value):
	maxHealth = max (value, 1)
	self.healthRemaining = min (healthRemaining, maxHealth)
	emit_signal ("max_health_changed", maxHealth)
	
func set_health (value):
	healthRemaining = clamp(value, 0, maxHealth)
	#print("Health: ", healthRemaining, " / ", maxHealth)
	
	emit_signal ("health_changed", healthRemaining)
	
	if (healthRemaining <= 0):
		emit_signal ("no_health")
	
