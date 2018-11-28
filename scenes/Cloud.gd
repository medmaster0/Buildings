extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#GLOBAL VARS
var TILE_SIZE = 16 

var size #how many tiles wide the cloud is

var sprites = [] #keeps track of all the sprites on the cloud
var shine_sprites = [] #keep track of all the shine aprites (that are transparent)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#random color
	var cloud_color = Color(randf(), randf(), randf())
	$CanvasLayer/Sprite.modulate = cloud_color
	
	#Choose random layer for cloud
	$CanvasLayer.layer  = -2 + randi()%5 
	
	#Add first base sprite to list
	sprites.append($CanvasLayer/Sprite)
	
	#random size
	size = 3+randi()%8
	for i in range(size):
		#Copy the existing one as a template
		var temp_sprite = $CanvasLayer/Sprite.duplicate()
		$CanvasLayer.add_child(temp_sprite)
		temp_sprite.position = Vector2((i+1)*TILE_SIZE,0)
		sprites.append(temp_sprite)
		
	#Put the shine under clouds
	giveCloudShine(cloud_color)
	
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	$CanvasLayer.offset = position
#	pass

#Function that changes the color of all the cloud sprites
func changeColor(color):
	for sprite in sprites:
		sprite.modulate = color
		
	#Change all of the shine colors, but keep the transparency level
	for shine_sprite in shine_sprites:
		shine_sprite.modulate = Color(color.r, color.g, color.b, shine_sprite.modulate.a)
		
#Function to set the cloud shine underneath the cloud
func giveCloudShine(color):
	var shine_height = 9 #how many tiles down the shine goes
	#Need to cycle through every cloud sprite and put them under
	for cloud_sprite in sprites:
		#Cycle through the variable height
		for i in shine_height:
			#Dublicate the existing shine (blank sprite)
			var temp_shine = $CanvasLayer/Sprite2.duplicate()
			$CanvasLayer.add_child(temp_shine)
			temp_shine.position = cloud_sprite.position + Vector2(0,(i+1)*TILE_SIZE)
			temp_shine.modulate = color
			temp_shine.modulate.a = 0.5 - (0.05*i)
			temp_shine.visible = true
			shine_sprites.append(temp_shine)
	