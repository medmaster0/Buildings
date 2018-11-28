extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var TILE_SIZE=16 #how big the tiles are
var GLOBAL_SCREEN_WIDTH #the width of the screen
var OUTSIDE_LAYER = 2 #What canvaslayer (zindex) the outside creatures start out with 
var INSIDE_LAYER = -2 #What canvaslayer (zindex) the inside creatures start out with

var step_tick = 0.5 #time period for each step
var step_timer = 0 #will help keep track of when we stepped

#BUILDING SPECIFIC GLOBALS
var isInside = false #whether creature is inside building or not (helps with layering)
var marker_tilemap #the tilemap for the outside markers (helps with creature moving)
					#SHOULD BE SET/LINKED BY OUTSIDE FUNCITON!!

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#calculate globals
	GLOBAL_SCREEN_WIDTH = get_viewport().size.x
	
	#Set layer
	z_index = OUTSIDE_LAYER
	
	#Set random color to sprite
	$Sprite2.modulate = Color(randf(),randf(),randf())
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	step_timer = step_timer + delta
	if step_timer > step_tick:
		step()
		#upadte timer
		step_timer = step_timer - step_tick
	
	pass


#function to step in a random direction
#does bounds checking
func step():
	var random_choice = randi()%3
	match(random_choice):
		0:
			position = position + Vector2(-TILE_SIZE,0)
			if position.x < 0:
				position.x = 0
				
			#Also make sure sprite is facing the right way
			$Sprite.flip_h = false
			$Sprite2.flip_h = false
		1:
			position = position + Vector2(TILE_SIZE,0)
			if position.x >= GLOBAL_SCREEN_WIDTH:
				position.x = GLOBAL_SCREEN_WIDTH-TILE_SIZE
				
			#Also make sure sprite is facing the right way
			$Sprite.flip_h = true
			$Sprite2.flip_h = true
	
	#Check if new position's tile is walkable or not (so we can change layers)
	var map_position = marker_tilemap.world_to_map(global_position)
	var tile_number = marker_tilemap.get_cellv(map_position)
	
	#There are two different behaviors
	# 1) Outside - can walk anywhere that's NOT air...?
	# 2) Inside - can walk anywhere that's NOT air AND must be inside building...
	#check which one it is
	var isInside
	if z_index == INSIDE_LAYER:
		isInside = true
	else:
		isInside = false
	
#	match tile_number:
#		0:
#			#Means we're on a Door tile
#			z_index = 
	
	
	




#Function that changes whether creature is inside or outside
func changeSide():
	isInside = !isInside #toggle
	
	#Now correct the layer
	if isInside == true:
		z_index = INSIDE_LAYER
	if isInside == false:
		z_index = OUTSIDE_LAYER