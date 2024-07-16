class_name LevelButton
extends Button
signal level_selected


var LEVEL_NAME : String:
	set(value):
		LEVEL_NAME = value


func _on_pressed():
	#debug print
	#print(LEVEL_NAME)
	level_selected.emit(LEVEL_NAME)
