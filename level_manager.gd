class_name LevelManager extends Node

const LevelScene = preload("res://level.tscn")

# Updated to include background paths
const LEVEL_LIST = "res://level_list.csv"

var BUILT_LEVEL_LIST: Dictionary = {}

func _ready():
	if make_level_list():
		print("Level list successfully built")
	else:
		print("Failed to build level list")


func get_level_list():
	return BUILT_LEVEL_LIST


func make_level_list() -> bool:
	var csv: Array = []
	var file = FileAccess.open(LEVEL_LIST, FileAccess.READ)
	if file == null:
		print("Failed to open file")
		return false

	while not file.eof_reached():
		var csv_rows = file.get_csv_line("|")
		if csv_rows[0]:
			csv.append(csv_rows)

	file.close()

	var csv_noheaders = csv
	csv_noheaders.pop_front()

	for item in csv_noheaders:
		# Ensure the item has all three elements: name, track, background path
		if len(item) == 3:
			_update_built_level_list(item[0], ["res://Assets/audio/" + item[1], item[2]])
		else:
			print("Invalid item format: %s" % item)

	return true


func _update_built_level_list(key: String, value: Array):
	BUILT_LEVEL_LIST[key] = value


func load_level(level_name: String) -> Level:
	if level_name is String:
		var new_level = LevelScene.instantiate() as Level
		if level_name in BUILT_LEVEL_LIST:
			new_level.setup(level_name, BUILT_LEVEL_LIST[level_name][0], BUILT_LEVEL_LIST[level_name][1])
			return new_level
		else:
			printerr("Level name %s not found in level list" % level_name)
	else:
		printerr("TypeError: param level_name %s is not a string" % level_name)
	return null
