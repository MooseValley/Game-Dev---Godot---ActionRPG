extends Area2D

# Used to push enemies away from each other if they are overlapping.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var pushVector = Vector2.ZERO
	
	if (is_colliding() == true) :
		# Get the 1st area colliding
		var area = areas[0]
		# Get vector that goes from the area we are colliding with to our position
		# So we are moving away from them
		pushVector = area.global_position.direction_to (global_position)
		pushVector = pushVector.normalized()
	
	return pushVector

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
