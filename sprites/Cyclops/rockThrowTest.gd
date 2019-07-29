extends Position2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rockCount=0
var rockFlag = false

const ROCK = preload("res://sprites/Cyclops/rock.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process(false) # TODO
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rockFlag:
		var rock = ROCK.instance()
		# add position2d to player
		rock.position = self.global_position
		rock.velocity.x = rand_range(-300,300)
		rock.velocity.y = -rand_range(-500,500)
		# adding to stage one scene. not player
		get_parent().add_child(rock)
		rockFlag=false
	pass
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		rockFlag = true
		pass