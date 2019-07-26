extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
var attack_power = 100 #power of damage
var hit_count = 0 # the number of times damage is done
export var hp = 400


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
	var body = $Area2D.get_overlapping_bodies()
	if Input.is_action_just_pressed("ui_select"):
		_change_state(ATTACK)
		pass
	match current_state:
		IDLE:
			$AnimatedSprite.play("idle")
			pass
		WALK:
			for b in body:
				if b.has_meta("character"):
					_change_state(ATTACK)
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
				$Area2D/CollisionShape2D.position.x *= -1 
				$CollisionShape2D.position.x *= -1
				
			if $RayCast2D.is_colliding() == false:
				direction = direction * -1
				$RayCast2D.position.x *= -1
				$Area2D/CollisionShape2D.position.x *= -1
				$CollisionShape2D.position.x *= -1
		ATTACK:
			$AnimatedSprite.play("attack")
			for b in body:
				if $AnimatedSprite.frame == 7 and hit_count==0:
					hit_count+=1 # a hit with this attack
					if b.has_method("damage"):
						b.damage(attack_power)
		DEAD:
			pass
 
func _on_AnimatedSprite_animation_finished():
	var body = $Area2D.get_overlapping_bodies()
	if current_state==ATTACK:
		if len(body):
			for b in body:
				if b.has_meta("character"):
					$AnimatedSprite.frame = 0
					break
				else:
					_change_state(WALK)
		else:
			_change_state(WALK)
		hit_count=0 # start with zero
	elif current_state==IDLE:
		_change_state(WALK)
	if is_dead == true:
		queue_free()