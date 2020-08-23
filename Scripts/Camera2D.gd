extends Camera2D


onready var topLeft     = $CameraLimits/TopLeft
onready var bottomRight = $CameraLimits/BottomRight

func _ready():
	# Set Camera Limits based on TopLeft and BottomRight Position2D nodes.
	limit_top    = topLeft.position.y
	limit_left   = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right  = bottomRight.position.x

