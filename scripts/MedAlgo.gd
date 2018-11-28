extends Node

#Caclulate the "opposite color"
#This is the color with each of it's rgb channels 128 (or 0.5) away from the color
#ex. (255,108,176) and (128,236,48)
func oppositeColor(in_col):
	
	var r = in_col.r + 0.5
	if r > 1:
		r = r - 1
	var g = in_col.g + 0.5
	if g > 1:
		g = g - 1
	var b = in_col.b + 0.5
	if b > 1:
		b = b - 1
	
	var out_col = Color(r,g,b)
	return out_col
	
	
#Determine which color will better contrast input color:
#Black or White?	
func contrastColor(in_col):
	
	var in_brightness_count = 0 #this will keep track of which channels are bright (over 0.5)
	if in_col.r > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.g > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.b > 0.5:
		in_brightness_count = in_brightness_count + 1
		
	#If the majority of channels are bright, return black (for contrast)
	if in_brightness_count >=2:
		return(Color(0,0,0))
	#Otherwise return white
	else: 
		return(Color(1,1,1))
	
	
#Blend two colors
func blendColor(col1, col2):
	
	var r = (col1.r+col2.r)/2.0
	var g = (col1.g+col2.g)/2.0
	var b = (col1.b+col2.b)/2.0
	return( Color(r,g,b) )
	
#Generate color cycle schema
#These are meant to be moody color that cycle unto each other
#Right now, RANDOM
#eventually more artistic and shit
#Things we can filter:
	#Green? doesn't look good as a sky
	#blue? pure doesn't look good as a sky neither...
	#too much red will get boring, some otherworldy is cool
	# like one or two out of all of them can be freaky, but no more
func colorCycle():
	
	randomize() #randomize just to be safe, fuckhead
	
	var colors = [] #the list of colors that form the cycle
	
	#now add some random colors boyeee
	var cycle_length = randi()%3 + 3
	for i in range(cycle_length):
		colors.append(Color(randf(),randf(), randf()))
	
	return colors
	
#MAYBE TODO????????
#Generates a discrete list of colors to go through
#that slowly changes ino one from the other
#Will list colors to get from color1 to color2, in random RGB increments

#Function that will return a color a step in the "direction" of the other step
func colorTransitionStep(color1,color2):
	
	#Determine how big of steps to adjust each color channel in
	var STEP_SIZE = 0.0125
	
	var temp_color = color1 #the color we'll be returning (will be manipulated but starts at color1)
	
	#We first need to analyze which channels need to go higher or lower
	var shouldGoUp = [] #will hold boolean values indicating if channel should go up or down
	for i in range(3):
		if color1[i] < color2[i]: #If target is greater
			shouldGoUp.append(true)
		else: #then target is lower
			shouldGoUp.append(false)
			
	#Need to pick which channel (R,G, or B) we'll change
	var channel_choice = randi()%3 
	match(channel_choice):
		0:
			#Chose Red
			#Check array for if we should increment or decrement
			if shouldGoUp[0] == true:
				temp_color.r = temp_color.r + STEP_SIZE
			else:
				temp_color.r = temp_color.r - STEP_SIZE
		1:
			#Chose Green
			#Check array for if we should increment or decrement
			if shouldGoUp[1] == true:
				temp_color.g = temp_color.g + STEP_SIZE
			else:
				temp_color.g = temp_color.g - STEP_SIZE
		2:
			#Chose Blue
			#Check array for if we should increment or decrement
			if shouldGoUp[2] == true:
				temp_color.b = temp_color.b + STEP_SIZE
			else:
				temp_color.b = temp_color.b - STEP_SIZE
	
	return(temp_color)
	