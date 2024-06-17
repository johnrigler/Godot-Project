class_name LevelLoader extends Object



# this class is for handling world/level loading procedures, to be called by the Main.gd script when a new level is required


static func load_level(world_name: String, level_name : String):
	if world_name is String || level_name is String:
		pass
	else:
		printerr("TypeError: param world_name %s" %world_name, " or param level_name %s" %level_name, " is not a String" )
	# should return a Level object
	pass


#not sure I need this function yet
static func prepare_next_level(level_name : ):
	pass
	


