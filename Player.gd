extends KinematicBody2D

const SPEED = 75
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1) # to tell the up side of the floor, needed for is_on_floor() func

# loading fireball scene
const FIREBALL = preload("res://fireball.tscn")

var velocity = Vector2()


var on_ground = false
var is_attacking = false

func _physics_process(delta):
	
		

	if Input.is_action_pressed("ui_right") :
	
		velocity.x = SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
		
		# if position 2d is on the left side then switch it to opposite side.
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
		
		# if position 2d is on right side then switch to opposite side
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
		
		
	else:
		velocity.x = 0
		if on_ground == true:
			$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_up"):
		if on_ground == true:
			velocity.y = JUMP_POWER
			
			
	
	
	
	# key to shoot fireball
	if Input.is_action_just_pressed("ui_focus_next"):
		var fireball = FIREBALL.instance() # creating instance, created one fireball in memory
		$AnimatedSprite.play("attack")
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		# adding to stage one scene. not player
		get_parent().add_child(fireball)
		# add position2d to player
		fireball.position = $Position2D.global_position
		
	
	if is_on_floor():
		on_ground = true
	else: 
		on_ground = false
		
	
	if on_ground == false:
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	
	
	

	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
    


