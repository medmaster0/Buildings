extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Cloud
export (PackedScene) var Streetlight
export (PackedScene) var Creature
export (PackedScene) var Building

#GLOBAL VARS
var STREETLIGHT_LAYER = 3 #the layer of the streetlights (should be in front of OUTSIDE creature)

var background_color
var background_tick = 2 #How often the background changes color (slightly)
var background_timer = 0 #keeps track of how long it's been since background last changed
var color_cycle = [] #A list of colors to cycle the background through

#Scenery Vars
var cloud_color #the color of all the clouds on the map
var clouds = [] #keeps track of all the clouds in the game
var light_color #keeps track of the color of the streetlights
var streetlights = [] #keeps track of all the streetlights in the game

var buildings = [] #keeps track of all the building scenes in game

var creatures = [] #list to keep track of all the creatures on the screen

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Set up background
	background_color = Color(randf(), randf(), randf())
	$CanvasLayer/Background.scale = get_viewport().size
	$CanvasLayer/Background.set_modulate( background_color )
	
	#Screen Dimension stuff
	var world_width = get_viewport().size.x
	var world_height = get_viewport().size.y
	var map_width = int($MarkerTileMap.world_to_map(Vector2(world_width,0)).x)
	var map_height = int($MarkerTileMap.world_to_map(Vector2(0,world_height)).y)
	
#	#Random cloud colors
#	cloud_color = Color(randf(), randf(), randf())
#	var num_clouds = 5+randi()%10 #how many clouds to create on start
#	for i in range(num_clouds):
#		var temp_cloud = Cloud.instance()
#		temp_cloud.get_child(0).offset =  $MarkerTileMap.map_to_world( Vector2(randi()%60 ,randi()%20)  )
#		add_child(temp_cloud)
#		clouds.append(temp_cloud)
#		temp_cloud.changeColor(cloud_color)
	
	#Create some random creatures
	var num_creatures = 10
	for i in range(num_creatures):
		var temp_creature = Creature.instance()
		add_child(temp_creature)
		temp_creature.position = $MarkerTileMap.map_to_world( Vector2(randi()%map_width,map_height)   )
		creatures.append(temp_creature)
		#Also link creature to the MarkerTileMap
		temp_creature.marker_tilemap = $MarkerTileMap
	
	#Sprinkle With StreetLights
	light_color = Color(randf(), randf(), randf())
	for i in range(4):
		var temp_streetlight = Streetlight.instance()
		add_child(temp_streetlight)
		streetlights.append(temp_streetlight)
		temp_streetlight.position = $MarkerTileMap.map_to_world( Vector2(randi()%map_width,map_height)   )
		temp_streetlight.change_color(light_color)
		temp_streetlight.z_index = STREETLIGHT_LAYER
		

	#We need to sync the MarkerTileMap with our buildings and creatures somehow....
	#MarkerTileMap Legend
	# Tile #0: Door
	# Tile #1: Front Balcony (creatures can't change layers on it)
	# Tile #2: Side Balcony (creatures CAN change layers on it - going inside or outside)
	# Tile #3: Inside building (but no balcony) - NEED TO IMPLEMENT
	# Tile #4: OUtside walking path - NEED TO IMPLEMENT
	# Tile #5: Air - NEED TO IMPLEMENT
	#Cycle through and create buildings
	for i in range(2):
		var temp_building = Building.instance()
		temp_building.position = $MarkerTileMap.map_to_world(Vector2(10+18*i,map_height))
		add_child(temp_building)
		buildings.append(temp_building)
		#Need to also set the values in $MarkerTileMap: 2 side balcony, 1 front balcony, 0: door
		temp_building.set_balcony_tiles($MarkerTileMap)
		temp_building.set_inside_tiles($MarkerTileMap)
		#Door: 5 away from building position
		#This door_position needs to be in MAP COORDS!!
		var door_position = $MarkerTileMap.world_to_map(temp_building.position) + Vector2(5,-1)
		$MarkerTileMap.set_cellv(door_position, 0)
	
	#Register a list of colors we'll cycle through
	color_cycle = MedAlgo.colorCycle()
	
	#SOMEM ORE SHITTY DEBUG FUCKHEAD GOD DAMN I HAVENT SLEEPT I WANNA FECUKING SNOOOZE HOLY FUCK
	#create sum clouds the color of the color cycle
	for color in color_cycle:
		#CREATE A CLOUD OF THAT COLOR
		var temp_cloud = Cloud.instance()
		temp_cloud.get_child(0).offset =  $MarkerTileMap.map_to_world( Vector2(randi()%60 ,randi()%20)  )
		add_child(temp_cloud)
		clouds.append(temp_cloud)
		temp_cloud.changeColor(color)

	print(MedAlgo.colorTransitionStep(color_cycle[0], color_cycle[1]) )

func _process(delta):
	
	#Do do background stuff
	background_timer = background_timer + delta
	if background_timer > background_tick:
		
		#Time to change the muthafuckin bakcground
		print("do it muthafucka")
		print("target:")
		print(color_cycle[0])
		background_color = MedAlgo.colorTransitionStep(background_color, color_cycle[0])
		print("current:")
		print(background_color)
		$CanvasLayer/Background.modulate = background_color
		
		background_timer = background_timer - background_tick
		#also change background_tick size for even  more noise
		#background_tick = randf() + 1.5
		background_tick = 0.5
	
	pass
