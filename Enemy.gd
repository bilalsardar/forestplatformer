extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
export var hp = 50


var is_dead = false

enum {IDLE, WALK, ATTACK, DEAD} # see enum in godot
var current_state = IDLE

func _ready():
	self.set_meta("character","Skeleton")
	$HealthBar.creat_healthBar(hp)
	_change_state(WALK)
	#_change_state(ATTACK) # this is the skeleton state
	pass

func _change_state(new_state):
	current_state = new_state

func damage(hitpoints):
	hp = hp - hitpoints;
	$HealthBar.update_healthBar(hp)
	if hp <= 0 :
		is_dead = true
		_change_state(DEAD)
		velocity = Vector2(0,0)
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play("dead")
		
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		_change_state(ATTACK)
		pass
	match current_state:
		IDLE:
			$AnimatedSprite.play("idle")
			pass
		WALK:
			velocity.x = SPEED * direction
			if direction == 1:
				$AnimatedSprite.flip_h = false
			else:
				$AnimatedSprite.flip_h = true
				
			$AnimatedSprite.play("walk")
			
			velocity.y +=GRAVITY
			
			velocity = move_and_slide(velocity,FLOOR)
			if is_on_wall():
				direction = direction * -1
				$RayCast2D.position.x *= -1
			
			if $RayCast2D.is_colliding() == false:
				direction = direction * -1
				$RayCast2D.position.x *= -1
		ATTACK:
			$AnimatedSprite.play("attack")
		DEAD:
			pass

 
func _on_AnimatedSprite_animation_finished():
	if current_state==ATTACK:
		_change_state(IDLE)
		$AnimatedSprite.position = Vector2(0,0)
	elif current_state==IDLE:
		_change_state(WALK)
	if is_dead == true:
		queue_free()
	
