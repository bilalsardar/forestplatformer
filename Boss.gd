extends KinematicBody2D

const GRAVITY = 10
export var SPEED = 10
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
var is_attacking = false
export var hp = 300
var fireBallCount=0

# loading fireball scene
const FIREBALL = preload("res://fireball.tscn")


var is_dead = false


func _ready():
	self.set_meta("tpye","Boss")
	if direction == 1:
		#This tyoe of child node addressing is name dependent
		#AnimatedSprite node must exist of this type
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	pass
#This function is used to damage the boss
func damage(hitpoints):
	#apply damage
	hp = hp - hitpoints;
	if hp <= 0 :
		is_dead = true
		velocity = Vector2(0,0)
		#$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		queue_free()
	#change color depanding on remaining hp
	if hp < 100:
		self.modulate = Color(1,1,1)
	
func myprint(text):
	$RichTextLabel.set_text(text)
	
func _physics_process(delta):
	myprint(str(hp))
	if is_dead == false:
		velocity.x = SPEED * -direction
		$AnimatedSprite.play("walk") # or walk
	#Change direction and if time up is reached
	if is_on_wall() && $Timer.is_stopped():
		direction = direction * -1
		$RayCast2D.rotation_degrees *= -1
		$Position2D.position.x *= -1
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		$Timer.start()
	# boss will attack when inside raycast 
	if $RayCast2D.is_colliding() == true:
		#The collider Object reference
		var colObj = $RayCast2D.get_collider()
		if colObj.has_meta("type"): # colObj.has_method("damage"):
			$AnimatedSprite.play("idle")
			is_attacking = true
			velocity.x = 0
			var fireball = FIREBALL.instance() # creating instance, created one fireball in memory
			fireball._random_fireball_color("Boss")
			fireBallCount+=1 # a fireball is created
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
	
	
		
		
