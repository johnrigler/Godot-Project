class_name LevelButton
extends Button
signal level_selected

var LEVEL_NAME

# Called when the node enters the scene tree for the first time.
func setup(level):
	if _valid_level_name(level):
		LEVEL_NAME = level
		text = LEVEL_NAME
	else:
		printerr("%s is not of type: string" %level)


func _valid_level_name(file : String):
	if file is String:
		return true
	else:
		return false
	

func _on_pressed():
	#debug print
	#print(LEVEL_NAME)
	level_selected.emit(LEVEL_NAME)
