extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right


func _ready():
	pass 

func _physics_process(delta):
	velocity.x = SPEED * direction
	
	$AnimatedSprite.play("walk")
	
	velocity.y +=GRAVITY
	
	velocity = move_and_slide(velocity,FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$AnimatedSprite.flip_h = true
	