extends Control

# NOTE: Make sure Expand On is checked for the HeartUIFull TexttureRect
# otherwise the last FULL health heart wont dissappear when the player dies (no health).

const HEART_IMAGE_WIDTH = 15

var hearts    = 4 setget set_hearts
var maxHearts = 4 setget set_max_hearts

#onready var label = $Label
onready var heartUIFull  = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

func _ready():
	self.maxHearts = PlayerStatsNode.maxHealth
	self.hearts    = PlayerStatsNode.healthRemaining
	# warning-ignore:return_value_discarded
	PlayerStatsNode.connect ("health_changed",     self, "set_hearts")
	# warning-ignore:return_value_discarded
	PlayerStatsNode.connect ("max_health_changed", self, "set_max_hearts")

func set_hearts (value):
	hearts = clamp(value, 0, maxHearts)

	#if (label != null):
	#	label.text = "HP: " + str (hearts)

	if (heartUIFull != null):
		heartUIFull.rect_size.x = hearts     * HEART_IMAGE_WIDTH

func set_max_hearts (value):
	# Can never be less than 1
	maxHearts   = max (value, 1)
	self.hearts = min (hearts, maxHearts)

	if (heartUIEmpty != null):
		heartUIEmpty.rect_size.x = maxHearts * HEART_IMAGE_WIDTH

