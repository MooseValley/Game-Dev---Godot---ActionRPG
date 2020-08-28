extends Node2D

onready var stats                = $StatsNode

onready var sprite = $Sprite

var framesOfAnimation = 0
var healthRemaining


# Called when the node enters the scene tree for the first time.
func _ready():
	framesOfAnimation = sprite.hframes
	print (stats.healthRemaining, " of ", stats.maxHealth)


func _on_Hurtbox_area_entered(area):
	stats.healthRemaining -= area.damageDone
	var healthPct = 1.0 * stats.healthRemaining / stats.maxHealth
	var healthFrame =  healthPct * framesOfAnimation
	print (stats.healthRemaining, " of ", stats.maxHealth, " -> frame: ", healthFrame)
	sprite.frame = framesOfAnimation - healthFrame

func _on_StatsNode_no_health():
	queue_free()
