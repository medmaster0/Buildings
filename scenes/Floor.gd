extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Window
export (PackedScene) var Door
export (PackedScene) var Balcony

#GLOBAL VARS
var TILE_SIZE = 16 #A constant for how big a tile is
var DARK_WINDOW_LAYER = 1 #The layer where dark windows are (should be between OUTSIDE creatures and INSIDE creatures
var LIGHT_WINDOW_LAYER = -3 #for light windows (should be behind INSIDE creature
var DOOR_LAYER = DARK_WINDOW_LAYER #door layer (should be the same as Dark windows for now

var block_windows = [] #a list to keep track of all the windows (that are "blocking") (same color as building)
var dark_windows = [] #a list to keep track of all the windows that are "dark" (black and top layer (to block what's "inside"
var light_windows = [] #a list to keep track of which windows are lightly colored (background, but bottom layer so you can see what's "inside")
var doors = [] #list to keep track of all the doors on the map
var balconies = [] #list of keep track of all the balconies on the floor

var building_color #gloabl to keep track of what color the building is
var light_color #gloabl for color of lights

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	building_color = Color(randf(), randf(), randf())
	light_color = Color(randf(), randf(), randf())
	$Sprite.modulate = building_color
	
	#Cover the entire floor with windows
	createWindows()
	placeBalconies()
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#Function that creates a grid of windows
func createWindows():
	for j in range(4):
		for i in range(10):
			var temp_window = Window.instance()
			temp_window.position = Vector2(16*i, -16*j-16) 
			
			#POSSIBLy make same color)
			if randi()%2==0:
				#An actual window
				#Choose light or dark
				if randi()%2 == 0:
					#light window
					temp_window.modulate = light_color
					light_windows.append(temp_window)
					temp_window.z_index = LIGHT_WINDOW_LAYER
				else:
					#dark window
					temp_window.modulate = Color(0,0,0)
					dark_windows.append(temp_window)
					temp_window.z_index = DARK_WINDOW_LAYER
			else:
				#Block window, same color as building
				temp_window.modulate = building_color
				block_windows.append(temp_window) #Only add it, if it will be visible...
			
			add_child(temp_window)

#function to change the building color
func changeBuildingColor(color):
	building_color = color
	$Sprite.modulate = building_color
	
	#Also need to change the block_windows
	for window in block_windows:
		window.modulate = building_color
	
#Function to change the light color
func changeLightColor(color):
	light_color = color
	for window in light_windows:
		window.modulate = color
	
#Function to place a door on (bottom) floor	
func placeDoor():
	var temp_door = Door.instance()
	temp_door.get_child(0).modulate = Color(randf(), randf(), randf())
	temp_door.get_child(1).modulate = Color(randf(), randf(), randf())
	temp_door.position = Vector2(16*5,-16)
	add_child(temp_door)
	doors.append(temp_door)
	temp_door.z_index = DOOR_LAYER
	
#Function to place balconies,..
#Randomly goes up the sides and places balconies
func placeBalconies():
	for i in range(4): #i is floor number
		if i == 0:
			continue #Don't do floor 1
		
		#Random choice: 0) a single LEFT balcony 1) a single RIGHT 2)ALl the way along FRONT 3) NO BALCONY
		var random_choice = randi()%4
		match(random_choice):
			0:
				#Place a balcony on left
				var temp_balcony = Balcony.instance()
				temp_balcony.position =  Vector2(-1*TILE_SIZE, -(1+i)*TILE_SIZE)
				temp_balcony.setDirection(random_choice)
				add_child(temp_balcony)
				balconies.append(temp_balcony)
			1:
				#Place a balcony on right
				var temp_balcony = Balcony.instance()
				temp_balcony.position =  Vector2(10*TILE_SIZE, -(1+i)*TILE_SIZE)
				temp_balcony.setDirection(random_choice)
				add_child(temp_balcony)
				balconies.append(temp_balcony)
			2:
				#All the way along FRONT
				#Place a balcony on both right and left
				#LEFT
				var temp_balcony = Balcony.instance()
				temp_balcony.position =  Vector2(-1*TILE_SIZE, -(1+i)*TILE_SIZE)
				temp_balcony.setDirection(0)
				add_child(temp_balcony)
				balconies.append(temp_balcony)
				#RIGHT
				temp_balcony = Balcony.instance()
				temp_balcony.position =  Vector2(10*TILE_SIZE, -(1+i)*TILE_SIZE)
				temp_balcony.setDirection(1)
				add_child(temp_balcony)
				balconies.append(temp_balcony)
				#NOW ALL THE ONES IN BETWEEN FOR FRONT
				for j in range(10):
					temp_balcony = Balcony.instance()
					temp_balcony.position = Vector2(j*TILE_SIZE, -(1+i)*TILE_SIZE)
					temp_balcony.setDirection(2)
					add_child(temp_balcony)
					balconies.append(temp_balcony)
				
			3: 
				continue

