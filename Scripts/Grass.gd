extends Node2D
#
# drag and drop the dir path and name from the FileSystem window !!!
#onready var GrassEffect = load("res://Scenes/GrassEffect.tscn")
const GrassEffect = preload("res://Scenes/GrassEffect.tscn")


#func _process(delta):

func create_grass_effect():
	# Make sure you write "attack" in lower case in the Grass.dg script or the grass will NOT dissappear when you attack:
	#if Input.is_action_just_pressed("attack"):
	var grassEffect = GrassEffect.instance()
	
	#var rootScene   = get_tree().current_scene
	#rootScene.add_child(grassEffect)
	get_parent().add_child(grassEffect)
	
	# Set the grassEffect to the position of the Grass.
	grassEffect.global_position = global_position
	
	queue_free()

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
