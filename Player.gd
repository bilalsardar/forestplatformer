extends KinematicBody2D

const SPEED = 75
const GRAVITY = 10
const JUMP_POWER = -300
const FLOOR = Vector2(0, -1) # to tell the up side of the floor, needed for is_on_floor() func

# loading fireball scene
const FIREBALL = preload("res://fireball.tscn")

var velocity = Vector2()
var hp = 1000

var on_ground = false
var is_attacking = false
var camera_offset = 50
var camera_smoothing = 2
 
var is_dead = false

func _ready():
	self.set_meta("type","Player")
	pass

func damage(hitpoints):
	hp = hp - hitpoints;
	if hp <= 0 :
		is_dead = true
		queue_free()

func _physics_process(delta):
	if Input.is_action_pressed("ui_right") :
		if is_attacking == false || is_on_floor() == false:
			
			velocity.x = SPEED
			
			if $Camera2D.offset.x <= camera_offset:
				$Camera2D.offset.x += camera_smoothing
			
			
			if is_attacking == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = false
				
				# if position 2d is on the left side then switch it to opposite side.
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	
	elif Input.is_action_pressed("ui_left"):
		if is_attacking == false || is_on_floor() == false:
			
			velocity.x = -SPEED
			
			if $Camera2D.offset.x >= -camera_offset:
				$Camera2D.offset.x -= camera_smoothing
			
			if is_attacking == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = true
					
				# if position 2d is on right side then switch to opposite side
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
		
		
	else:
		velocity.x = 0
		if on_ground == true && is_attacking == false:
			$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_up"):
		if is_attacking == false:
			if on_ground == true:
				velocity.y = JUMP_POWER
				on_ground = false
			
			
	
	
	
	# key to shoot fireball
	if Input.is_action_just_pressed("ui_focus_next") && is_attacking == false:
		is_attacking = true
		$AnimatedSprite.play("attack")
		
		velocity.x = 0
		
		var fireball = FIREBALL.instance() # creating instance, created one fireball in memory
		fireball._random_fireball_color("Player")
		
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		# adding to stage one scene. not player
		get_parent().add_child(fireball)
		# add position2d to player
		fireball.position = $Position2D.global_position
		

	
	if is_on_floor():
		if on_ground == false:
			is_attacking = false
		on_ground = true
	else: 
		on_ground = false
		if is_attacking == false:
	
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
	
	
	

	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
    



func _on_AnimatedSprite_animation_finished():
	is_attacking = false
