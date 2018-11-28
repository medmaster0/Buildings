extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#global vars
var TILE_SIZE = 16 #size of the tiles

var light_color #the color of light the lamp throws
var light_tiles = [] #list of tiles of the lights

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Setup the lights
	light_color = Color(randf(),randf(), randf())
	set_lights(light_color)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#function to set up the lights
func set_lights(color):
	
	#The template of our lampshade tiles (transparent)
	$Sprite2.modulate = color
	$Sprite2.modulate.a = 0.5
	
	#Do left lampshade
	for i in range(3):
		var temp_light = $Sprite2.duplicate()
		temp_light.position = Vector2(-TILE_SIZE,-i*TILE_SIZE-8)
		add_child(temp_light)
		light_tiles.append(temp_light)
		temp_light.visible = true
		
	#Do left lampshade
	for i in range(3):
		var temp_light = $Sprite2.duplicate()
		temp_light.position = Vector2(TILE_SIZE,-i*TILE_SIZE-8)
		add_child(temp_light)
		light_tiles.append(temp_light)
		temp_light.visible = true
		
		
func change_color(color):
	for tile in light_tiles:
		tile.modulate = color
		tile.modulate.a = 0.5