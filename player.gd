extends KinematicBody2D

export var speed : int = 50

var direction : Vector2 = Vector2(0, 0)
var velocity  : Vector2 = Vector2(0, 0)

func _physics_process(_delta):
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	
	if (direction.x > 0):
		$AnimatedSprite.play("bounce_side")
		$AnimatedSprite.flip_h = false
	elif (direction.x < 0):
		$AnimatedSprite.play("bounce_side")
		$AnimatedSprite.flip_h = true
	elif (direction.y < 0):
		$AnimatedSprite.play("bounce_back")
	elif (direction.y > 0):
		$AnimatedSprite.play("bounce_front")
	
	velocity = direction.normalized() * speed
	
	velocity = move_and_slide(velocity)

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("idle_1")
	$AnimatedSprite.stop()
	pass # Replace with function body.
