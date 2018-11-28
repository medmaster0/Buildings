extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Floor

#GLOBAL VARS
var TILE_SIZE = 16

var building_color #global to keep track of what color the building is
var light_color #global for color of lights

var floors = [] #keeps track of how many "floors" there are - really stack of 4 floors

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#determine random colors
	building_color = Color(randf(), randf(), randf())
	light_color = Color(randf(), randf(), randf())
	
	#determine how many floors
	var num_floors = 3 + randi()%7
	for i in num_floors:
		#New floor instance
		var temp_floor = Floor.instance()
		add_child(temp_floor)
		floors.append(temp_floor)
		temp_floor.position = Vector2(0,-i*4*TILE_SIZE)
		
		#Make all the floors the same color
		temp_floor.changeBuildingColor(building_color)
		temp_floor.changeLightColor(light_color)
	
	#Place a door on the first floor
	floors[0].placeDoor()
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#function to set all the balconies on the given tilemap
#cycles through all the balconies
#then set the correct tile in the inputted tilemap
#Set the tiles to either:
	#Tile 2 - Front balcony
	#Tile 3 - Side Balcony
func set_balcony_tiles(tilemap):
	#Cycle through every floor
	for building_floor in floors:
		#Cycle through that floor's balcony set
		for balcony in building_floor.balconies:
#			#First find the coordinates of the 1) balcony, 2) floor its on, 3) building it's in
#			#The MAP coords of the balcony relative to the position of the FLOOR it's on
#			var balcony_coords = tilemap.world_to_map(balcony.position) 
#			#The MAP coords of the floor the balcony is on, relative to the BUILDING the floor is on
#			var floor_coords = tilemap.world_to_map(balcony.get_parent().position) 
#			#The MAP coords of the building, the floor is on (GLOBAL posiiton)
#			var building_coords = tilemap.world_to_map(balcony.get_parent().get_parent().position)
#			#Now combine them all to find the global position of the balcony...
#			var map_coords = balcony_coords + floor_coords + building_coords
			
			
			#Find the MAP coords of the balcony both 1) relative to game and 2) relative to the floor it's on
			#The MAP coords of the balcony relative to it's floor (used for type of balcony checking)
			var floor_coords = tilemap.world_to_map(balcony.position)
			#The MAP coords of the balcony relative to the game 
			var game_coords = tilemap.world_to_map(balcony.global_position)
			
			#Do a quick test to check if balcony is a side balcony
			#Do this by checking the bounds of the balcony
			var isSide = false
			if floor_coords.x < 0 || floor_coords.x >= 10:
				isSide = true
			
			#Now set the proper tile in the tilemap (using game_coords)
			if isSide == true:
				tilemap.set_cellv(game_coords,3)
			else:
				tilemap.set_cellv(game_coords,2)

#Function to set all the inside tiles on the given tilemap
#Cycles through all the floors
#And sets all of the coords on the map to the proper inside tile
#Set the tiles to:
	#Tile 3 - Inside building (but no balcony)
#CALL AFTER SET BALCONY TILES since it checks if the tile has been set already...
func set_inside_tiles(tilemap):
#	#Cycle through every floor
#	for building_floor in floors:
#		print(":hi mom")

	#Figure out how many floors it has...
	var num_floors = floors.size()
	#Each floors has 4 "rows of windows"
	var num_rows = num_floors*4
	
	#MAP coords of the building
	var map_coords = tilemap.world_to_map(global_position)
	
	#Now, starting with the building coords, go one by one
	#setting all of the tiles in tilemap that need to be set
	#skip if already set
	var temp_map_coords
	#for all of the rows
	for i in num_rows:
		#for all of the tiles in the row (10 rows per tile)
		for j in range(10):
			temp_map_coords = map_coords + Vector2(j,-(i+1))
			var tile_number = tilemap.get_cellv(temp_map_coords)
			if tile_number == -1: #if it hasn't been set already (will add more criteria later)
				#let's set it as 3 - inside building
				tilemap.set_cellv(temp_map_coords,4)

				
			