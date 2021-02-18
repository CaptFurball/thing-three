extends KinematicBody2D

export var speed : int = 2

var velocity : Vector2

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		velocity.y -= speed
		$AnimatedSprite.play("bounce_back")
	
	if Input.is_action_pressed("move_down"):
		velocity.y += speed
		$AnimatedSprite.play("bounce_front")
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= speed
		$AnimatedSprite.play("bounce_side")
		$AnimatedSprite.flip_h = true		
		
	if Input.is_action_pressed("move_right"):
		velocity.x += speed
		$AnimatedSprite.play("bounce_side")
		$AnimatedSprite.flip_h = false

	move_and_collide(velocity)


func _on_AnimatedSprite_animation_finished():
#	$AnimatedSprite.play("idle_1")
	$AnimatedSprite.stop()
	pass # Replace with function body.
