extends KinematicBody2D

const GRAVITY = 10
const SPEED = 10
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
var is_attacking = false
var hp = 300



# loading fireball scene
const FIREBALL = preload("res://fireball.tscn")


var is_dead = false


func _ready():
	pass 
	

	
func dead(hitpoints):
	
	hp = hp - hitpoints;
	
	if hp <= 0 :
		is_dead = true
		velocity = Vector2(0,0)
		#$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		queue_free()
	
	
func _physics_process(delta):
	
	if is_dead == false:
		
		velocity.x = SPEED * direction
		
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
		
		$AnimatedSprite.play("idle") # or walk
			
		
		
		
	if is_on_wall():
		direction = direction * -1
		
		
	
	# boss will attack when inside raycast 
	if $RayCast2D.is_colliding() == true:
		
		
		#$AnimatedSprite.play("attack")
		is_attacking = true
		velocity.x = 0
		
		var fireball = FIREBALL.instance() # creating instance, created one fireball in memory
		fireball._random_fireball_color("Boss")
		
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		# adding to stage one scene. not player
		get_parent().add_child(fireball)
		# add position2d to player
		fireball.position = $Position2D.global_position
		
		
		
		
			
		
		
		
		
	
	velocity.y +=GRAVITY
	velocity = move_and_slide(velocity,FLOOR)
	
	
		
		
