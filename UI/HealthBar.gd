extends Control

var totalBars
var progBars = [] #array
export var factor=1 #This is the measure how much health per pixel(rect.size)

#var hp=410
#func _ready():
#	setFactor(10)
#	creat_healthBar(hp)
#	pass # Replace with function body.
#
#func _physics_process(delta):
#	# Called when the node enters the scene tree for the first time.
#	if Input.is_action_just_pressed("ui_focus_next"):
#		hp=hp-10
#		update_healthBar(hp)
#		print(hp)
func update_healthBar(currentHealth):
	var remainingHealth = currentHealth
	var containerSize = self.rect_size.x
	for i in progBars:
		#distribute the health in the health bars
		if remainingHealth >= containerSize*factor:
			i.rect_size.x = containerSize
			remainingHealth -= containerSize*factor
			pass
		else:
			i.rect_size.x = remainingHealth/factor
			# this is the last bar all the other bars will have zero width
			remainingHealth = 0 
			pass
		pass
	pass
func setFactor(var f):
	factor=f
	pass
func creat_healthBar(var health):
	# the size of container
	var contSize = self.rect_size.x
	totalBars = round(health / (contSize * factor))#math is process differently then C/C++
	var i=0
	while i<=totalBars:
		progBars.insert(i,ColorRect.new())
		progBars[i].set_name("Health"+str(i))
		add_child(progBars[i])
		progBars[i].rect_size.y = 2
		progBars[i].rect_size.x = contSize
		progBars[i].color = getBarColor(i,0.8)
		i += 1
	self.update_healthBar(health)
# This function provide the color depending
# on the order on bar
func getBarColor(var num, var factor):
	var color
	# this is like switch case with auto break
	match num:
		0:
			 color = Color(factor,0,0) # Red
		1:
			color = Color(factor,factor,0) # Yellow
		2:
			color = Color(0,factor,0) # Green
		3:
			color = Color(0,factor,factor) # Ligh Blue
		4:
			color = Color(0,0,factor) # Bule
		5:
			color = Color(factor,0,factor) # Purple
	return color