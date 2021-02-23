extends Camera2D

# Lower cap for the `_zoom_level`.
export var min_zoom := 0.5

# Upper cap for the `_zoom_level`.
export var max_zoom := 2.0

# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 0.1

# Duration of the zoom's tween animation.
export var zoom_duration := 0.2

var zoom_level := 1.0 setget set_zoom_level

onready var tween : Tween = $Tween

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if Input.is_action_just_released("zoom_in"):
		self.zoom_level = zoom_level - zoom_factor
	elif Input.is_action_just_released("zoom_out"):
		self.zoom_level = zoom_level + zoom_factor

func set_zoom_level(value: float) -> void:
	zoom_level = clamp(value, min_zoom, max_zoom)
	
	self.tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(zoom_level, zoom_level),
		zoom_duration,
		self.tween.TRANS_SINE,
		self.tween.EASE_OUT
	)

	self.tween.start()
		
