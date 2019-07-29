extends KinematicBody2D

const GRAVITY = 10
const SPEED = 50
const FLOOR = Vector2(0,-1)
const ROCK = preload("res://sprites/Cyclops/rock.tscn")

var velocity = Vector2()
var direction = 1 #we keeping default to right
var flip_sprite = false
var ATTACK_POWER = 50 #power of damage
var hit_count = 0 # the number of times damage is done
var rockCount = 0 # number of rocks to generate
var hp = 300


var is_dead = false
signal _direction_changed()

enum {BASIC, ROCK_THROW, LASER}
enum {IDLE, WALK, ATTACK, DEAD} # see enum in godot
var current_state = IDLE
var attack_type = BASIC
func _ready():
	self.set_meta("character","Cyclops")
	$HealthBar.creat_healthBar(hp)
	_change_state(IDLE)
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
		attack_type = ROCK_THROW
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
				$RayCast2D_RockThrow.cast_to.x *= -1
				$Area2D.position.x *= -1 
				$CollisionShape2D.position.x *= -1
				$Timer.start()
				emit_signal("_direction_changed")
				
			if $RayCast2D.is_colliding() == false:
				direction = direction * -1
				$RayCast2D.position.x *= -1
				$RayCast2D_RockThrow.cast_to.x *= -1
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
								b.damage(ATTACK_POWER)
								hit_count+=1 # a hit with this attack
				ROCK_THROW:
					$AnimatedSprite.play("attack_rock")
					if $AnimatedSprite.frame == 11 and rockCount==0:
						rockCount+=1
						var rock = ROCK.instance() # creating instance, created one fireball in memory
						# add position2d to player
						if $RayCast2D_RockThrow.is_colliding() == true:
							var t=1
							var g=147.0 #gravity in pixels / sec
							var h=30.0 #hight in pixels
							print($RayCast2D_RockThrow.get_collider().name)
							#distance in pixels
							var distance = self.global_position.distance_to($RayCast2D_RockThrow.get_collision_point())
							var Vx = distance / (t)
							t *= 0.5
							var Vy = (h/t) + ((g*t)/2.0)
							Vy *= 0.5 # this works dont know why
							Vy *= -1 #change sign
							Vx *= direction
							print(Vector2(Vx,Vy))
							rock.velocity = Vector2(Vx,Vy)
						# adding to stage one scene. not player
						get_parent().add_child(rock)
						rock.position = $Position2D.global_position
						pass
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
		rockCount=0
	elif current_state==IDLE:
		_change_state(WALK)
		pass
	elif current_state == DEAD:
		queue_free()