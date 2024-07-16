extends Node2D

@onready var current_level = $Level
@onready var menu = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	#$LevelManager.make_level_list()
	print(LevelManager.get_levels())
	print(LevelManager.get_taps())
	#switch_level("1-1")
	# debug print
	#print(level_loader.get_level_list())

#
## debug func
#func switch_level(level_name : String):
	#print("entered switch_level")
	#if "Level" in get_tree_string():
		#var next_level = $LevelManager.load_level(level_name)
		#remove_child(current_level)
		#current_level.queue_free()
		#current_level = next_level
		#current_level.connect("level_end", Callable(self, "_on_level_level_end"))
		#add_child(current_level)
		#current_level = $Level
		#current_level.start_track()
		#print("exiting switch_level")
#
#
#func _on_level_level_end(level_name, score):
	#print(level_name, ": ", score)
	#var next_level = "1-%s" %(int(level_name[-1])+1)
	#switch_level(next_level)
