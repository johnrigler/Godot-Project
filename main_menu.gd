extends Control

# I don't yet know whether or not these signals are needed
signal start_continue
signal level_select
signal quit_request

var LevelSelectScene = preload("res://level_select_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_start_button_pressed():
	print("I'm sorry, Dave. I'm afraid I can't do that.")
	start_continue.emit()


func _on_level_select_pressed():
	print("level select screen selected")
	level_select.emit()


func _on_quit_button_pressed():
	quit_request.emit()
