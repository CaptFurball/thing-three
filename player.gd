extends KinematicBody2D

export(int, 20, 80, 1) var speed : int = 50

var direction : Vector2 = Vector2.ZERO
var velocity  : Vector2 = Vector2.ZERO
var speed_mod : float = 1.0
var is_moving : bool = false

onready var anim_sprite : AnimatedSprite = $AnimatedSprite

func _ready():
	capture_mouse()

func _input(event):
	if event is InputEventMouseButton:
		capture_mouse()

func _physics_process(_delta):
	handle_movement()

func handle_movement():
	direction = Vector2.ZERO
	speed_mod = 1.0

	if Input.is_action_pressed("move_up"):
		direction = direction + Vector2.UP

	if Input.is_action_pressed("move_down"):
		direction = direction + Vector2.DOWN

	if Input.is_action_pressed("move_left"):
		direction = direction + Vector2.LEFT

	if Input.is_action_pressed("move_right"):
		direction = direction + Vector2.RIGHT

	if (direction != Vector2.ZERO):
		anim_sprite.play("slide")
		calculate_speed_mod()		

	if Input.is_action_pressed("jump"):
		anim_sprite.play("bounce")		

	velocity = direction.normalized() * speed * speed_mod
	velocity = move_and_slide(velocity)

func calculate_speed_mod():
	var frame_count : float = float(anim_sprite.frames.get_frame_count(anim_sprite.animation))
	speed_mod = abs(sin((float(anim_sprite.frame) / frame_count) * 3.142))
	speed_mod = clamp(speed_mod, 0.2, 1)

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_AnimatedSprite_animation_finished():
	anim_sprite.play("idle")
	anim_sprite.stop()
	pass # Replace with function body.
