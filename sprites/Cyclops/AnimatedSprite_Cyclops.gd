extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var idle_offset = [Vector2(0,0),Vector2(0,-0.5),Vector2(0,-0.5),Vector2(0,-0.5)
				,Vector2(0,0),Vector2(0,0),Vector2(0,-0.5),Vector2(0,-0.5)
				,Vector2(0,-0.5),Vector2(0,0),Vector2(0,0),Vector2(0,-0.5)
				,Vector2(0,-0.5),Vector2(0,-0.5),Vector2(0,0)]
				
var walk_offset = [Vector2(0,0),Vector2(0,1.5),Vector2(0,0.5),Vector2(0,0)
				,Vector2(0,1.5),Vector2(0,0),Vector2(0,0),Vector2(0,1.5)
				,Vector2(0,0),Vector2(0,0),Vector2(0,1.5),Vector2(0,0)]

var attack_rock_offset = [Vector2(0,0),Vector2(0,2.5),Vector2(0,4),Vector2(0,4)
					,Vector2(0,2.5),Vector2(0,0),Vector2(0,0),Vector2(0,0)
					,Vector2(0,-2.5),Vector2(-3,-2.5),Vector2(-4,-2.5),Vector2(8.5,0)
					,Vector2(8.5,0)
					]
var death_offset = [Vector2(0,0),Vector2(0,3),Vector2(0,4),Vector2(0,5)
					,Vector2(0,7),Vector2(0,10),Vector2(0,12),Vector2(0,12)
					,Vector2(0,12)
					]

var attack_basic_offset = [Vector2(0,0),Vector2(0,0),Vector2(-0.5,0),Vector2(-0.5,0)
					,Vector2(-0.5,2),Vector2(-0.5,1),Vector2(-0.5,0)]

var damage1_offset = [Vector2(0,0),Vector2(0,1),Vector2(0,0.5)]
var damage2_offset = [Vector2(0,0),Vector2(0,1),Vector2(0,1),Vector2(0,1),Vector2(0,0)]
var direction_x = 1 # this is need to make the offset work in both direction
func _on_AnimatedSprite_frame_changed():
	var fram_offset
	if self.animation == "idle":
		fram_offset = idle_offset[self.frame]
	elif self.animation == "walk":
		fram_offset = walk_offset[self.frame]
	elif self.animation == "attack_basic":
		fram_offset = attack_basic_offset[self.frame]
	elif self.animation == "attack_rock":
		fram_offset = attack_rock_offset[self.frame]
	elif self.animation == "dead":
		fram_offset = death_offset[self.frame]
	elif self.animation == "damage1":
		fram_offset = death_offset[self.frame]
		
	fram_offset.x *= direction_x
	self.set_offset(fram_offset)
	pass # Replace with function body.


func _on_Cyclops__direction_changed():
	direction_x *= -1
	pass # Replace with function body.
