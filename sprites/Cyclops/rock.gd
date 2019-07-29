extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 147.0 # 1meter is 30pixel -> 9.8m/s = 147pix/s
const FRICTION = 1
var hitCount = 0
var attack_power = 30
var velocity = Vector2(50,-180)
const FLOOR = Vector2(0,-1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	#gravit apply in all states
	if is_on_floor():
		if velocity.x > 0:
			velocity.x -=FRICTION
		elif velocity.x < 0:
			velocity.x +=FRICTION
		else:
			velocity.x = 0
	velocity.y += (GRAVITY/60.0) # point to force float, as the process is called 60 fram/sec
	velocity = move_and_slide(velocity,FLOOR)
	#get collision
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_method("damage") and hitCount==0:
			collision.collider.damage(attack_power)
			hitCount+=1
    #print("Collided with: ", collision.collider.name)
	#check for time up first, otherwise it will restart the timer
	#restart the timer if not running
	if abs(velocity.y) < 1 and abs(velocity.y)>0 or velocity.y==0:
		if abs(velocity.x) <1 and abs(velocity.x)>0 or velocity.x==0:
			if $Timer.is_stopped():
				$Timer.start()

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
