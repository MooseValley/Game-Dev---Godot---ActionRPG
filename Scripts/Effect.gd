extends AnimatedSprite
#extends Node2D


#onready var animatedSprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
# when a GrassEffect is created / instanciated.
func _ready():
	#animatedSprite.frame = 0
	#animatedSprite.play("Animate")
	
	# Add a signal between the AnimateSprite and the function below so we can finish the animation:
	# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("Animate")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("attack"):
#		animatedSprite.frame = 0
#		animatedSprite.play("Animate")


func _on_animation_finished():
	queue_free()
