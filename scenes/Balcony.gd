extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	
	$Right.modulate = Color(0,0,0)
	$Left.modulate = Color(0,0,0)
	$Front.modulate = Color(0,0,0)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#INput a direction code for the balcony
#0 - Left
#1 - Right
#2 - Front
func setDirection(direction):
	
	#set all children invisible
	for child in get_children():
		child.visible = false
		
	#now set the right one visible
	get_child(direction).visible = true