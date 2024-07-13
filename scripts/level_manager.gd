class_name LevelManager extends Node

const LevelScene = preload("res://level.tscn")

# want this list to also include properties like background or w/e
const LEVEL_LIST = "res://level_list.csv"

# this should be created when the game is launched and treated as a const
var BUILT_LEVEL_LIST : Dictionary
## this class is for handling world/level loading procedures, to be
## called by the Main.gd script when a new level is required



func _on_ready():
	make_level_list()


# debug func
func get_level_list():
	return BUILT_LEVEL_LIST


func build_level_list():
	pass



# this needs to be modified to accept custom tracks from users
func make_level_list() -> bool:
	var csv : Array = []
	var file = FileAccess.open(LEVEL_LIST, FileAccess.READ)
	while !file.eof_reached():
		var csv_rows = file.get_csv_line("|")
		#print(csv_rows)
		if csv_rows[0]:
			csv.append(csv_rows)
		#print(csv)
	var csv_noheaders = csv
	csv_noheaders.pop_front()
	#print(csv_noheaders)
	for item in csv_noheaders:
		# debug print
		#print("res://Assets/audio/%s" %item[1])
		_update_built_level_list(item[0],["res://Assets/audio/" + item[1], (item[2])])
	return true


func _update_built_level_list(key : String, value : Array):
	BUILT_LEVEL_LIST[key] = value


func load_level(level_name : String) -> Level:
	if level_name is String:
		var new_level = LevelScene.instantiate() as Level
		new_level.setup(level_name, BUILT_LEVEL_LIST[level_name][0],BUILT_LEVEL_LIST[level_name][1])
		return new_level
	else:
		printerr("TypeError: param level_name %s is not a string" %level_name)
		return
