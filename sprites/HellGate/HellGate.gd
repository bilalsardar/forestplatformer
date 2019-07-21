extends Position2D
var time
const SKELETON = preload("res://Enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	# cannot instance skeleton here
	time = Timer.new()
	#auto load timer will casue issue
	time.one_shot = true
	time.start(5)
	add_child(time)
	pass # Replace with function body.
func _physics_process(delta):
	var skeletonCount=0
	if time.is_stopped():
		# get referenece of the enemies group
		var ememies = get_tree().get_nodes_in_group("Enemies")
		for x in ememies:
			#if it contains the hell gate name
			if x.name.find(self.name)!=-1:
				skeletonCount+=1
			pass
		if skeletonCount<5:
			var skeleton = SKELETON.instance()
			skeleton.name= self.name + "_skull"
			# adding to stage one scene. not player
			get_parent().add_child(skeleton)
			skeleton.add_to_group("Enemies") 
			skeleton.position = self.global_position
		time.start() #restart timer when finished
	pass