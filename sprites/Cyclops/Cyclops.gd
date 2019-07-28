extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0,-1)


var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
var attack_power = 30 #power of damage
var hit_count = 0 # the number of times damage is done
var hp = 300


var is_dead = false
signal _direction_changed()

enum {BASIC, ROCK, LASER}
enum {IDLE, WALK, ATTACK, DEAD} # see enum in godot
var current_state = IDLE
var attack_type = BASIC
func _ready():
	self.set_meta("character","Cyclops")
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
		_change_state(DEAD)
		
func _physics_process(delta):
	var body = $Area2D.get_overlapping_bodies()
	if Input.is_action_just_pressed("ui_select"):
		_change_state(ATTACK)
		pass
	match current_state:
		IDLE:
			velocity.x = 0 # stop moving
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
			
			if is_on_wall() and $Timer.is_stopped():
				direction = direction * -1
				$RayCast2D.position.x *= -1
				$Area2D.position.x *= -1 
				$CollisionShape2D.position.x *= -1
				$Timer.start()
				emit_signal("_direction_changed")
				
			if $RayCast2D.is_colliding() == false:
				direction = direction * -1
				$RayCast2D.position.x *= -1
				$Area2D.position.x *= -1
				$CollisionShape2D.position.x *= -1
				emit_signal("_direction_changed")
		ATTACK:
			velocity.x = 0
			match attack_type:
				BASIC:
					$AnimatedSprite.play("attack_basic")
					if $AnimatedSprite.frame == 4:
						for b in body:
							if b.has_method("damage") and hit_count==0:
								b.damage(attack_power)
								hit_count+=1 # a hit with this attack
				ROCK:
					pass
				LASER:
					pass
		DEAD:
			is_dead = true
			velocity = Vector2(0,0)
			$AnimatedSprite.play("dead")
			pass
	#gravit apply in all states
	velocity.y +=GRAVITY
	velocity = move_and_slide(velocity,FLOOR)
 
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
			_change_state(IDLE)
		hit_count=0 # start with zero
	elif current_state==IDLE:
		_change_state(WALK)
	elif current_state == DEAD:
		queue_free()