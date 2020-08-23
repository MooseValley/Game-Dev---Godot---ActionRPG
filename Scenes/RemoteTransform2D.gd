extends RemoteTransform2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var main = get_tree().current_scene
	var camera2D = main.get_node("Camera2D")
	#set_remote_node (camera2D)
	#set_remote_node ("/root/Camera2D")
	#var camera2DStr = camera2D.to_string()
	#NodePath (camera2D)

	# This works - but Level_01 is hard-coded = yeuck !!!
	#set_remote_node ("/root/Level_01/Camera2D")
	#print(main.name)
	#print(camera2D.name)
	#print(camera2DStr)
	var fullPathName = "/root/" + main.name + "/" + camera2D.name
	print(fullPathName)  # To check.  This will give you something like:  /root/Level_01/Camera2D, etc
	set_remote_node (fullPathName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
