extends KinematicBody2D

var velocity

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 5
	
	if Input.is_action_pressed("move_down"):
		velocity.y += 5
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= 5
		
	if Input.is_action_pressed("move_right"):
		velocity.x += 5

	move_and_collide(velocity)
