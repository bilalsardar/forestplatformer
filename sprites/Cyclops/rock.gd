extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 10

var velocity = Vector2()
const FLOOR = Vector2(0,-1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	#gravit apply in all states
	velocity.x += 10
	velocity.y +=GRAVITY
	velocity = move_and_slide(velocity,FLOOR)
	pass