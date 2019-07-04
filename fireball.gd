extends Node2D

const SPEED = 150
var velocity = Vector2()
var direction = 1 # default right
var hitpoints = 20;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	# multiply by direction. 
	# direction is 1 or -1, multiplying it will move it in -x or +x axis
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_FireBall_body_entered(body):
	if "Enemy" in body.name:
		body.dead(hitpoints)
	elif "Boss" in body.name:
		body.dead(hitpoints)
	elif "Player" in body.name:
		body.dead(hitpoints)
	queue_free()
	
func _random_fireball_color(shooter):
	if shooter == "Player":
		var R = randf()*0.9+0.1
		#var G = randf()*0.9+0.1
	
		$AnimatedSprite.modulate = Color(0.8, R, R)
		
	elif shooter == "Boss":
		#75,0,130
		var R = randf()*0.9+0.5
		var G = randf()*0.9+0.1
		
		$AnimatedSprite.modulate = Color(R,0,130)
		
		
	elif shooter == "Enemy":
		pass
	